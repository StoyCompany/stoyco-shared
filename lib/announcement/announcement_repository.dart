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
/// );
/// ```
class AnnouncementRepository {
  AnnouncementRepository({
    required AnnouncementDataSource announcementDataSource,
  }) : _announcementDataSource = announcementDataSource;

  final AnnouncementDataSource _announcementDataSource;

  /// Retrieves a paginated list of announcements based on the provided filters.
  ///
  /// Returns an [Either] containing either a [Failure] or a [PageResult] of [AnnouncementModel]s.
  ///
  /// Parameters:
  /// - [filters]: The filter parameters for the query
  ///
  /// Example:
  /// ```dart
  /// final filterRequest = FilterRequest(page: 1, pageSize: 10);
  /// final result = await announcementRepo.getAnnouncementsPaginated(filterRequest);
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (pageResult) => pageResult.items.forEach((announcement) => print(announcement.title)),
  /// );
  /// ```
  Future<Either<Failure, PageResult<AnnouncementModel>>>
      getAnnouncementsPaginated(FilterRequest filters) async {
    try {
      final response = await _announcementDataSource.getPaged(filters: filters);

      final PageResult<AnnouncementModel> pageResult =
          PageResult<AnnouncementModel>.fromJson(
        response.data,
        (item) => AnnouncementMapper.fromDto(
          AnnouncementDto.fromJson(item as Map<String, dynamic>),
        ),
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

  /// Retrieves a specific announcement by its ID.
  ///
  /// Returns an [Either] containing either a [Failure] or an [AnnouncementModel].
  ///
  /// Parameters:
  /// - [announcementId]: The unique identifier of the announcement to retrieve
  ///
  /// Example:
  /// ```dart
  /// final announcementId = 'announcement123';
  /// final result = await announcementRepo.getAnnouncementById(announcementId);
  ///
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (announcement) => print('Found announcement: ${announcement.title}'),
  /// );
  /// ```
  Future<Either<Failure, AnnouncementModel>> getAnnouncementById(
    String announcementId,
  ) async {
    try {
      final response = await _announcementDataSource.getById(
        announcementId: announcementId,
      );

      final AnnouncementModel announcement = AnnouncementMapper.fromDto(
        AnnouncementDto.fromJson(response.data as Map<String, dynamic>),
      );
      return Right(announcement);
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
}
