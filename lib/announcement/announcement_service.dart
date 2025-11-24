import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:stoyco_shared/announcement/announcement_data_source.dart';
import 'package:stoyco_shared/announcement/announcement_repository.dart';
import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation/announcement_participation.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation_response/announcement_participation_response.dart';
import 'package:stoyco_shared/announcement/models/user_announcement/user_announcement.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/utils/filter_request.dart';
import 'package:stoyco_shared/utils/logger.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';

/// A service for managing announcements in the application.
///
/// This service follows a singleton pattern and is responsible for:
/// - Checking if there are active announcements
/// - Fetching announcements by ID
/// - Getting paginated announcement lists
/// - Handling user participation in announcements
/// - Validating subscription access for announcements
///
/// Example usage:
/// ```dart
/// final announcementService = AnnouncementService(
///   remoteConfig: FirebaseRemoteConfig.instance,
///   environment: StoycoEnvironment.production,
///   activeSubscriptionService: ActiveSubscriptionService(...),
/// );
///
/// // Check if there are active announcements
/// bool hasActive = announcementService.hasActiveAnnouncement();
///
/// // Get announcement by ID with subscription validation
/// final announcement = await announcementService.getAnnouncementById(
///   'ann123',
///   partnerId: 'partner123',
/// );
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
  /// - [activeSubscriptionService]: Service for validating subscription access.
  ///
  /// Example:
  /// ```dart
  /// final service = AnnouncementService(
  ///   remoteConfig: FirebaseRemoteConfig.instance,
  ///   environment: StoycoEnvironment.production,
  ///   activeSubscriptionService: ActiveSubscriptionService(...),
  /// );
  /// ```
  factory AnnouncementService({
    required FirebaseRemoteConfig remoteConfig,
    required StoycoEnvironment environment,
    required ActiveSubscriptionService activeSubscriptionService,
  }) {
    // For testing, we'll return a new instance each time if instance is not null
    // This allows us to reset the singleton in tests
    if (_instance != null &&
        remoteConfig != _instance!.remoteConfig &&
        environment != _instance!.environment) {
      return AnnouncementService._(
        remoteConfig: remoteConfig,
        environment: environment,
        activeSubscriptionService: activeSubscriptionService,
      );
    }

    _instance ??= AnnouncementService._(
      remoteConfig: remoteConfig,
      environment: environment,
      activeSubscriptionService: activeSubscriptionService,
    );
    return _instance!;
  }

  /// Private constructor for the singleton pattern.
  ///
  /// Initializes the data source and repository for announcements with subscription validation.
  ///
  /// Parameters:
  /// - [remoteConfig]: The Firebase Remote Config instance.
  /// - [environment]: The environment configuration.
  /// - [activeSubscriptionService]: Service for validating subscription access.
  AnnouncementService._({
    required this.remoteConfig,
    required this.environment,
    required ActiveSubscriptionService activeSubscriptionService,
  }) {
    _announcementDataSource = AnnouncementDataSource(
      environment: environment,
    );
    _announcementRepository = AnnouncementRepository(
      announcementDataSource: _announcementDataSource!,
      activeSubscriptionService: activeSubscriptionService,
    );

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
  /// - [activeSubscriptionService]: Service for validating subscription access.
  ///
  /// Returns an instance of [AnnouncementService].
  ///
  /// Example:
  /// ```dart
  /// final service = AnnouncementService.getInstance(
  ///   remoteConfig: FirebaseRemoteConfig.instance,
  ///   environment: StoycoEnvironment.production,
  ///   activeSubscriptionService: ActiveSubscriptionService(...),
  /// );
  /// ```
  static AnnouncementService getInstance({
    required FirebaseRemoteConfig remoteConfig,
    required StoycoEnvironment environment,
    required ActiveSubscriptionService activeSubscriptionService,
  }) {
    _instance ??= AnnouncementService._(
      remoteConfig: remoteConfig,
      environment: environment,
      activeSubscriptionService: activeSubscriptionService,
    );
    return _instance!;
  }

  /// Checks if there is an active announcement.
  ///
  /// Reads the 'enable_announcement_v2' flag from Firebase Remote Config.
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
          remoteConfig.getBool('enable_announcement_v2');
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

  /// Fetches an announcement by its ID with subscription validation.
  ///
  /// Parameters:
  /// - [announcementId]: The ID of the announcement to fetch.
  /// - [partnerId]: Optional partner ID for subscription validation.
  ///
  /// Returns an [Either] containing either a [Failure] or the [AnnouncementModel]
  /// with `hasAccessWithSubscription` field properly set.
  ///
  /// Example:
  /// ```dart
  /// final result = await announcementService.getAnnouncementById(
  ///   'ann123',
  ///   partnerId: 'partner123',
  /// );
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (announcement) {
  ///     print('Announcement title: ${announcement.title}');
  ///     print('Has access: ${announcement.hasAccessWithSubscription}');
  ///   }
  /// );
  /// ```
  Future<Either<Failure, AnnouncementModel>> getAnnouncementById(
    String announcementId, {
    String? partnerId,
  }) async =>
      _announcementRepository!.getAnnouncementById(
        announcementId,
        partnerId: partnerId,
      );

  /// Marks an announcement as viewed.
  ///
  /// Parameters:
  /// - [announcementId]: The ID of the announcement to mark as viewed.
  ///
  /// Returns an [Either] containing either a [Failure] or a boolean.
  ///
  /// Example:
  /// ```dart
  /// final result = await announcementService.markAsViewed('ann123');
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (success) => print('Marked as viewed: $success')
  /// );
  /// ```
  Future<Either<Failure, bool>> markAsViewed(String announcementId) async =>
      _announcementRepository!.markAsViewed(announcementId);

  /// Gets a paginated list of announcements based on the provided filters with subscription validation.
  ///
  /// Parameters:
  /// - [filters]: The filter criteria for the announcements.
  /// - [partnerId]: Optional partner ID for subscription validation.
  ///
  /// Returns an [Either] containing either a [Failure] or a [PageResult] of [AnnouncementModel]
  /// with each announcement having `hasAccessWithSubscription` properly set.
  ///
  /// Example:
  /// ```dart
  /// final filters = FilterRequest(page: 1, pageSize: 10);
  /// final result = await announcementService.getAnnouncementPaginated(
  ///   filters,
  ///   partnerId: 'partner123',
  /// );
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (pageResult) {
  ///     print('Total announcements: ${pageResult.totalItems}');
  ///     pageResult.items?.forEach((announcement) {
  ///       print('${announcement.title} - Has access: ${announcement.hasAccessWithSubscription}');
  ///     });
  ///   }
  /// );
  /// ```
  Future<Either<Failure, PageResult<AnnouncementModel>>>
      getAnnouncementPaginated(
    FilterRequest filters, {
    String? partnerId,
  }) async =>
          _instance!._announcementRepository!.getAnnouncementsPaginated(
            filters,
            partnerId: partnerId,
          );

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

  /// Gets the leadership board for a specific announcement.
  ///
  /// Parameters:
  /// - [announcementId]: The ID of the announcement
  /// - [pageNumber]: The page number for pagination
  /// - [pageSize]: The number of items per page
  ///
  /// Returns an [Either] containing either a [Failure] or a [PageResult] of [UserAnnouncement].
  ///
  /// Example:
  /// ```dart
  /// final result = await announcementService.getLeadershipBoard(
  ///   announcementId: 'ann123',
  ///   pageNumber: 1,
  ///   pageSize: 10,
  /// );
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (pageResult) => print('Total participants: ${pageResult.totalItems}')
  /// );
  /// ```
  Future<Either<Failure, PageResult<UserAnnouncement>>> getLeadershipBoard({
    required String announcementId,
    required int pageNumber,
    required int pageSize,
  }) async =>
      _announcementRepository!.getLeadershipBoard(
        announcementId: announcementId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

  /// Checks if there are active announcements.
  ///
  /// This method reads the 'enable_announcement_v2' flag from Firebase Remote Config
  /// to determine if there are active announcements in the system.
  ///
  /// Parameters:
  /// - [platform]: Optional platform identifier to check specific platform flags.
  ///
  /// Returns a [Future] containing a [bool]:
  /// - `true` if there are active announcements.
  /// - `false` if there are no active announcements or an error occurs.
  ///
  /// Example:
  /// ```dart
  /// final hasActive = await announcementService.hasActiveAnnouncements(
  ///   platform: 'web',
  /// );
  /// if (hasActive) {
  ///   print('There are active announcements.');
  /// } else {
  ///   print('No active announcements.');
  /// }
  /// ```
  Future<bool> hasActiveAnnouncements({String? platform}) async {
    try {
      final bool enableAnnouncement =
          remoteConfig.getBool('enable_announcement_$platform');
      return enableAnnouncement;
    } catch (e) {
      StoyCoLogger.error('Error checking active calls for applications: $e');
      return false;
    }
  }

  /// Checks if TikTok authentication is enabled.
  ///
  /// Returns `true` if TikTok auth is enabled, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (announcementService.isTiktokAuthEnabled()) {
  ///   // Show TikTok auth option
  /// }
  /// ```
  bool isTiktokAuthEnabled() {
    try {
      final bool enableTiktokAuth = remoteConfig.getBool('enable_tiktok_auth');
      return enableTiktokAuth;
    } catch (e) {
      StoyCoLogger.error('Error checking TikTok auth: $e');
      return false;
    }
  }
}
