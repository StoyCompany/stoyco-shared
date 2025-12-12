import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/announcement/announcement_data_source.dart';
import 'package:stoyco_shared/announcement/models/announcement_dto/announcement_dto.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation/announcement_participation.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation_response/announcement_participation_response.dart';
import 'package:stoyco_shared/announcement/utils/announcement_mappers.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/utils/filter_request.dart';
import 'package:stoyco_shared/announcement/models/user_announcement/user_announcement.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/active_subscription_service.dart';
import 'package:stoyco_subscription/pages/subscription_plans/data/mixins/content_access_validator_mixin.dart';

/// Repository for managing announcements.
///
/// This repository handles data operations on announcements, including
/// retrieving paginated announcements, getting announcement details by ID,
/// and handling announcement participation.
///
/// Example:
/// ```dart
/// final announcementRepo = AnnouncementRepository(
///   announcementDataSource: AnnouncementDataSource(dio),
///   activeSubscriptionService: ActiveSubscriptionService(...),
/// );
/// ```
class AnnouncementRepository with MultiContentAccessValidatorMixin {
  AnnouncementRepository({
    required AnnouncementDataSource announcementDataSource,
    required ActiveSubscriptionService activeSubscriptionService,
  })  : _announcementDataSource = announcementDataSource,
        _activeSubscriptionService = activeSubscriptionService;

  final AnnouncementDataSource _announcementDataSource;
  final ActiveSubscriptionService _activeSubscriptionService;

  /// Retrieves a paginated list of announcements based on the provided filters.
  ///
  /// Returns an [Either] containing either a [Failure] or a [PageResult] of [AnnouncementModel]s.
  ///
  /// This method automatically validates access to each announcement based on the user's
  /// active subscriptions and updates the `hasAccessWithSubscription` field accordingly.
  ///
  /// Parameters:
  /// - [filters]: The filter parameters for the query
  /// - [partnerId]: Optional partner ID to filter announcements by partner
  ///
  /// Example:
  /// ```dart
  /// final filterRequest = FilterRequest(page: 1, pageSize: 10);
  /// final result = await announcementRepo.getAnnouncementsPaginated(
  ///   filterRequest,
  ///   partnerId: 'partner123',
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (pageResult) => pageResult.items.forEach((announcement) {
  ///     print('${announcement.title} - Has access: ${announcement.hasAccessWithSubscription}');
  ///   }),
  /// );
  /// ```
  Future<Either<Failure, PageResult<AnnouncementModel>>>
      getAnnouncementsPaginated(
    FilterRequest filters, {
    String? partnerId,
  }) async {
    try {
      final response = await _announcementDataSource.getPaged(filters: filters);

      final PageResult<AnnouncementModel> pageResult =
          PageResult<AnnouncementModel>.fromJson(
        response.data,
        (item) => AnnouncementMapper.fromDto(
          AnnouncementDto.fromJson(item as Map<String, dynamic>),
        ),
      );

      // Validate access for all announcements
      if (pageResult.items != null && pageResult.items!.isNotEmpty) {
        final validatedAnnouncements =
            await validateMultipleAccess<AnnouncementModel>(
          service: _activeSubscriptionService,
          forceRefresh: true,
          contents: pageResult.items!,
          getAccessContent: (announcement) => announcement.accessContent,
          hasAccessToContent: (announcement, hasAccess) =>
              announcement.copyWith(hasAccessWithSubscription: hasAccess),
          getIsSubscriptionOnly: (announcement) =>
              announcement.isSubscriberOnly,
          partnerId: partnerId,
        );

        return Right(pageResult.copyWith(items: validatedAnnouncements));
      }

      return Right(pageResult);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Retrieves a specific announcement by its ID.
  ///
  /// Returns an [Either] containing either a [Failure] or an [AnnouncementModel].
  ///
  /// This method automatically validates access to the announcement based on the user's
  /// active subscriptions and updates the `hasAccessWithSubscription` field accordingly.
  ///
  /// Parameters:
  /// - [announcementId]: The unique identifier of the announcement to retrieve
  /// - [partnerId]: Optional partner ID for subscription validation
  ///
  /// Example:
  /// ```dart
  /// final announcementId = 'announcement123';
  /// final result = await announcementRepo.getAnnouncementById(
  ///   announcementId,
  ///   partnerId: 'partner123',
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (announcement) => print(
  ///     'Found announcement: ${announcement.title} - Has access: ${announcement.hasAccessWithSubscription}',
  ///   ),
  /// );
  /// ```
  Future<Either<Failure, AnnouncementModel>> getAnnouncementById(
    String announcementId, {
    String? partnerId,
  }) async {
    try {
      final response = await _announcementDataSource.getById(
        announcementId: announcementId,
      );

      final AnnouncementModel announcement = AnnouncementMapper.fromDto(
        AnnouncementDto.fromJson(response.data as Map<String, dynamic>),
      );

      // Validate access for the announcement
      final validatedAnnouncements =
          await validateMultipleAccess<AnnouncementModel>(
        service: _activeSubscriptionService,
        forceRefresh: true,
        contents: [announcement],
        getAccessContent: (ann) => ann.accessContent,
        hasAccessToContent: (ann, hasAccess) =>
            ann.copyWith(hasAccessWithSubscription: hasAccess),
        getIsSubscriptionOnly: (ann) => ann.isSubscriberOnly,
        partnerId: partnerId,
      );

      return Right(validatedAnnouncements.first);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Registers participation in an announcement.
  ///
  /// Returns an [Either] containing either a [Failure] or an [AnnouncementParticipationResponse].
  ///
  /// Parameters:
  /// - [announcementId]: The unique identifier of the announcement to participate in
  /// - [data]: The participation data to submit
  ///
  /// Example:
  /// ```dart
  /// final announcementId = 'announcement123';
  /// final participationData = AnnouncementParticipation(
  ///   userId: 'user456',
  ///   comments: 'I would like to participate',
  /// );
  ///
  /// final result = await announcementRepo.participate(
  ///   announcementId,
  ///   participationData,
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Participation failed: ${failure.message}'),
  ///   (response) => print('Successfully participated: ${response.status}'),
  /// );
  /// ```
  Future<Either<Failure, AnnouncementParticipationResponse>> participate(
    String announcementId,
    AnnouncementParticipation data,
  ) async {
    try {
      final response = await _announcementDataSource.participate(
        announcementId: announcementId,
        data: data,
      );

      final AnnouncementParticipationResponse announcement =
          AnnouncementParticipationResponse.fromJson(response.data);
      return Right(announcement);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Retrieves the leadership board for a specific announcement.
  ///
  /// Returns an [Either] containing either a [Failure] or a [PageResult] of [UserAnnouncement]s.
  ///
  /// Parameters:
  /// - [announcementId]: The unique identifier of the announcement
  /// - [pageNumber]: The page number for pagination
  /// - [pageSize]: The number of items per page
  ///
  /// Example:
  /// ```dart
  /// final result = await announcementRepo.getLeadershipBoard(
  ///   announcementId: 'announcement123',
  ///   pageNumber: 1,
  ///   pageSize: 10,
  /// );
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (pageResult) => pageResult.items.forEach((user) => print(user.score)),
  /// );
  /// ```
  Future<Either<Failure, PageResult<UserAnnouncement>>> getLeadershipBoard({
    required String announcementId,
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await _announcementDataSource.getLeadershipBoard(
        announcementId: announcementId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      final PageResult<UserAnnouncement> pageResult =
          PageResult<UserAnnouncement>.fromJson(
        response.data,
        (item) => UserAnnouncement.fromJson(item as Map<String, dynamic>),
      );
      return Right(pageResult);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Checks if there are any active announcements.
  ///
  /// This method retrieves a paginated list of announcements and checks if there
  /// are any active announcements available.
  ///
  /// Returns an [Either] containing either a [Failure] or a [bool].
  /// - [true]: If there are active announcements.
  /// - [false]: If there are no active announcements.
  ///
  /// Example:
  /// ```dart
  /// final result = await announcementRepo.hasActiveAnnouncements();
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (hasActive) => print('Has active announcements: $hasActive'),
  /// );
  /// ```
  Future<Either<Failure, bool>> hasActiveAnnouncements() async {
    try {
      final response = await getAnnouncementsPaginated(const FilterRequest());
      return response.isRight && (response.right.items?.isNotEmpty ?? false)
          ? const Right(true)
          : Left(
              ExceptionFailure.decode(
                Exception('No hay convocatorias activas'),
              ),
            );
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Marks an announcement as viewed.
  ///
  /// Returns an [Either] containing either a [Failure] or a [bool].
  /// - [true]: If the announcement was successfully marked as viewed.
  /// - [false]: If the operation failed.
  ///
  /// Parameters:
  /// - [announcementId]: The unique identifier of the announcement to mark as viewed.
  ///
  /// Example:
  /// ```dart
  /// final announcementId = 'announcement123';
  /// final result = await announcementRepo.markAsViewed(announcementId);
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (success) => print('Announcement marked as viewed: $success'),
  /// );
  /// ```
  Future<Either<Failure, bool>> markAsViewed(String announcementId) async {
    try {
      final response =
          await _announcementDataSource.markAsViewed(announcementId);
      return Right(response.statusCode == 200);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}
