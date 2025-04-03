import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:stoyco_shared/announcement/announcement_data_source.dart';
import 'package:stoyco_shared/announcement/announcement_repository.dart';
import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation/announcement_participation.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation_response/announcement_participation_response.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/utils/filter_request.dart';
import 'package:stoyco_shared/utils/logger.dart';

/// A service for managing announcements in the application.
///
/// This service follows a singleton pattern and is responsible for:
/// - Checking if there are active announcements
/// - Fetching announcements by ID
/// - Getting paginated announcement lists
/// - Handling user participation in announcements
///
/// Example usage:
/// ```dart
/// final announcementService = AnnouncementService(
///   remoteConfig: FirebaseRemoteConfig.instance,
///   environment: StoycoEnvironment.production,
/// );
///
/// // Check if there are active announcements
/// bool hasActive = announcementService.hasActiveAnnouncement();
///
/// // Get announcement by ID
/// final announcement = await announcementService.getAnnouncementById('ann123');
/// ```
class AnnouncementService {
  /// Creates or returns the singleton instance of [AnnouncementService].
  ///
  /// If an instance already exists but with different parameters, a new instance is returned.
  /// Otherwise, the existing instance is returned or a new one is created if none exists.
  ///
  /// Parameters:
  /// - [remoteConfig]: The Firebase Remote Config instance used for fetching configuration.
  /// - [environment]: The environment configuration for the service.
  ///
  /// Example:
  /// ```dart
  /// final service = AnnouncementService(
  ///   remoteConfig: FirebaseRemoteConfig.instance,
  ///   environment: StoycoEnvironment.production,
  /// );
  /// ```
  factory AnnouncementService({
    required FirebaseRemoteConfig remoteConfig,
    required StoycoEnvironment environment,
  }) {
    // For testing, we'll return a new instance each time if instance is not null
    // This allows us to reset the singleton in tests
    if (_instance != null &&
        remoteConfig != _instance!.remoteConfig &&
        environment != _instance!.environment) {
      return AnnouncementService._(
          remoteConfig: remoteConfig, environment: environment,);
    }

    _instance ??= AnnouncementService._(
        remoteConfig: remoteConfig, environment: environment,);
    return _instance!;
  }

  /// Private constructor for the singleton pattern.
  ///
  /// Initializes the data source and repository for announcements.
  ///
  /// Parameters:
  /// - [remoteConfig]: The Firebase Remote Config instance.
  /// - [environment]: The environment configuration.
  AnnouncementService._(
      {required this.remoteConfig, required this.environment,}) {
    _announcementDataSource = AnnouncementDataSource(
      environment: environment,
    );
    _announcementRepository = AnnouncementRepository(
        announcementDataSource: _announcementDataSource!,);

    _instance = this;
  }

  /// The singleton instance of [AnnouncementService].
  static AnnouncementService? _instance;

  /// Environment configuration used for initializing data sources and repositories.
  StoycoEnvironment environment;

  /// Data source used to fetch raw announcement data.
  AnnouncementDataSource? _announcementDataSource;

  /// Repository responsible for handling announcement operations.
  AnnouncementRepository? _announcementRepository;

  /// The Firebase Remote Config instance for fetching configuration.
  final FirebaseRemoteConfig remoteConfig;

  /// Resets the singleton instance for testing purposes.
  ///
  /// Example:
  /// ```dart
  /// // In a test setup
  /// void setUp() {
  ///   AnnouncementService.resetInstance();
  /// }
  /// ```
  static void resetInstance() {
    _instance = null;
  }

  /// Gets the singleton instance of [AnnouncementService].
  ///
  /// If no instance exists, one is created with the provided parameters.
  ///
  /// Parameters:
  /// - [remoteConfig]: The Firebase Remote Config instance.
  /// - [environment]: The environment configuration.
  ///
  /// Returns an instance of [AnnouncementService].
  ///
  /// Example:
  /// ```dart
  /// final service = AnnouncementService.getInstance(
  ///   remoteConfig: FirebaseRemoteConfig.instance,
  ///   environment: StoycoEnvironment.production,
  /// );
  /// ```
  static AnnouncementService getInstance({
    required FirebaseRemoteConfig remoteConfig,
    required StoycoEnvironment environment,
  }) {
    _instance ??= AnnouncementService._(
        remoteConfig: remoteConfig, environment: environment,);
    return _instance!;
  }

  /// Checks if there is an active announcement.
  ///
  /// Reads the 'enable_announcement' flag from Firebase Remote Config.
  ///
  /// Returns `true` if there is an active announcement, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (announcementService.hasActiveAnnouncement()) {
  ///   // Show announcement UI
  /// }
  /// ```
  bool hasActiveAnnouncement() {
    try {
      final bool enableAnnouncement =
          remoteConfig.getBool('enable_announcement');
      return enableAnnouncement;
    } catch (e) {
      StoyCoLogger.error('Error checking active calls for applications: $e');
      return false;
    }
  }

  /// Gets the configuration for the announcement participation form.
  ///
  /// Reads the 'tiktok_config' from Firebase Remote Config and converts it to
  /// an [AnnouncementParticipationViewConfig] object.
  ///
  /// Returns an [AnnouncementParticipationViewConfig] with the form configuration.
  ///
  /// Example:
  /// ```dart
  /// final config = announcementService.getParticipationFormConfig();
  /// // Use config to build the form UI
  /// ```
  AnnouncementParticipationViewConfig getParticipationFormConfig() {
    try {
      final String json = remoteConfig.getValue('tiktok_config').asString();

      final Map<String, dynamic> jsonMap = jsonDecode(json);

      return AnnouncementParticipationViewConfig.fromJson(jsonMap);
    } catch (e) {
      StoyCoLogger.error('Error getting participation form config: $e');
      return const AnnouncementParticipationViewConfig();
    }
  }

  /// Fetches an announcement by its ID.
  ///
  /// Parameters:
  /// - [newId]: The ID of the announcement to fetch.
  ///
  /// Returns an [Either] containing either a [Failure] or the [AnnouncementModel].
  ///
  /// Example:
  /// ```dart
  /// final result = await announcementService.getAnnouncementById('ann123');
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (announcement) => print('Announcement title: ${announcement.title}')
  /// );
  /// ```
  Future<Either<Failure, AnnouncementModel>> getAnnouncementById(
    String newId,
  ) async =>
      _announcementRepository!.getAnnouncementById(newId);

  /// Marks an announcement as viewed.
  ///
  /// This is a placeholder method that currently throws [UnimplementedError].
  ///
  /// Parameters:
  /// - [newId]: The ID of the announcement to mark as viewed.
  ///
  /// Returns an [Either] that would contain either a [Failure] or a boolean.
  ///
  /// Example of future usage:
  /// ```dart
  /// final result = await AnnouncementService.markAsViewed('ann123');
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (success) => print('Marked as viewed: $success')
  /// );
  /// ```
  static Future<Either<Failure, bool>> markAsViewed(String newId) async {
    throw UnimplementedError();
  }

  /// Gets a paginated list of announcements based on the provided filters.
  ///
  /// Parameters:
  /// - [filters]: The filter criteria for the announcements.
  ///
  /// Returns an [Either] containing either a [Failure] or a [PageResult] of [AnnouncementModel].
  ///
  /// Example:
  /// ```dart
  /// final filters = FilterRequest(page: 1, limit: 10);
  /// final result = await announcementService.getAnnouncementPaginated(filters);
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (pageResult) => print('Total announcements: ${pageResult.total}')
  /// );
  /// ```
  Future<Either<Failure, PageResult<AnnouncementModel>>>
      getAnnouncementPaginated(FilterRequest filters) async =>
          _instance!._announcementRepository!.getAnnouncementsPaginated(
            filters,
          );

  /// Gets a list of announcements related to the specified announcement.
  ///
  /// This is a placeholder method that currently throws [UnimplementedError].
  ///
  /// Parameters:
  /// - [newId]: The ID of the announcement to find related announcements for.
  ///
  /// Returns an [Either] that would contain either a [Failure] or a list of [AnnouncementModel].
  ///
  /// Example of future usage:
  /// ```dart
  /// final result = await AnnouncementService.relatedAnnouncement('ann123');
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (announcements) => print('Related count: ${announcements.length}')
  /// );
  /// ```
  static Future<Either<Failure, List<AnnouncementModel>>> relatedAnnouncement(
    String newId,
  ) async {
    throw UnimplementedError();
  }

  /// Submits a participation for a TikTok announcement.
  ///
  /// Parameters:
  /// - [announcementId]: The ID of the announcement to participate in.
  /// - [data]: The participation data.
  ///
  /// Returns an [Either] containing either a [Failure] or an [AnnouncementParticipationResponse].
  ///
  /// Example:
  /// ```dart
  /// final participation = AnnouncementParticipation(
  ///   userId: 'user123',
  ///   tiktokUrl: 'https://tiktok.com/video123',
  /// );
  /// final result = await announcementService.participateOnTiktokAnnouncement(
  ///   'ann123',
  ///   participation,
  /// );
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (response) => print('Participation successful: ${response.success}')
  /// );
  /// ```
  Future<Either<Failure, AnnouncementParticipationResponse>>
      participateOnTiktokAnnouncement(
    String announcementId,
    AnnouncementParticipation data,
  ) async =>
          _announcementRepository!.participate(
            announcementId,
            data,
          );
}
