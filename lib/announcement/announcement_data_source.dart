import 'package:dio/dio.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation/announcement_participation.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/utils/filter_request.dart';

class AnnouncementDataSource {
  AnnouncementDataSource({required this.environment});
  final Dio _dio = Dio();
  final StoycoEnvironment environment;

  Future<Response> getPaged({required FilterRequest filters}) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlAnnouncement}announcement',
      queryParameters: FilterRequestHelper.toQueryMap(filters),
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<Response> getById({required String announcementId}) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlAnnouncement}announcement/$announcementId',
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<Response> participate({
    required String announcementId,
    required AnnouncementParticipation data,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.post(
      '${environment.urlAnnouncement}announcement/$announcementId/publications',
      data: data,
      cancelToken: cancelToken,
    );

    return response;
  }
}
