import 'package:dio/dio.dart';
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
}
