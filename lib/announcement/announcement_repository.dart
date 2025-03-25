import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/announcement/announcement_data_source.dart';
import 'package:stoyco_shared/announcement/models/announcement_dto/announcement_dto.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';
import 'package:stoyco_shared/announcement/utils/announcement_mappers.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/utils/filter_request.dart';

class AnnouncementRepository {
  AnnouncementRepository({
    required AnnouncementDataSource announcementDataSource,
  }) : _announcementDataSource = announcementDataSource;

  final AnnouncementDataSource _announcementDataSource;

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
}
