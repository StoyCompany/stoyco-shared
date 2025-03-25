import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:stoyco_shared/announcement/announcement_data_source.dart';
import 'package:stoyco_shared/announcement/announcement_repository.dart';
import 'package:stoyco_shared/announcement/models/announcement_form_config.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/utils/filter_request.dart';
import 'package:stoyco_shared/utils/logger.dart';

class AnnouncementService {
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
          remoteConfig: remoteConfig, environment: environment);
    }

    _instance ??= AnnouncementService._(
        remoteConfig: remoteConfig, environment: environment);
    return _instance!;
  }

  AnnouncementService._(
      {required this.remoteConfig, required this.environment}) {
    _announcementDataSource = AnnouncementDataSource(
      environment: environment,
    );
    _announcementRepository = AnnouncementRepository(
        announcementDataSource: _announcementDataSource!);

    _instance = this;
  }

  static AnnouncementService? _instance;

  /// Environment configuration used for initializing data sources and repositories.
  StoycoEnvironment environment;

  /// Data source used to fetch raw announcement data.
  AnnouncementDataSource? _announcementDataSource;

  /// Repository responsible for handling announcement operations.
  AnnouncementRepository? _announcementRepository;

  final FirebaseRemoteConfig remoteConfig;

  // Add a method to reset the instance for testing purposes
  static void resetInstance() {
    _instance = null;
  }

  static AnnouncementService getInstance({
    required FirebaseRemoteConfig remoteConfig,
    required StoycoEnvironment environment,
  }) {
    _instance ??= AnnouncementService._(
        remoteConfig: remoteConfig, environment: environment);
    return _instance!;
  }

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

  Future<Either<Failure, AnnouncementModel>> getAnnouncementById(
    String newId,
  ) async =>
      _announcementRepository!.getAnnouncementById(newId);

  static Future<Either<Failure, bool>> markAsViewed(String newId) async {
    throw UnimplementedError();
  }

  Future<Either<Failure, PageResult<AnnouncementModel>>>
      getAnnouncementPaginated(FilterRequest filters) async =>
          _instance!._announcementRepository!.getAnnouncementsPaginated(
            filters,
          );

  //relatedAnnouncement
  static Future<Either<Failure, List<AnnouncementModel>>> relatedAnnouncement(
    String newId,
  ) async {
    throw UnimplementedError();
  }
}
