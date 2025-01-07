import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';

class NewsDataSource {
  NewsDataSource({required this.environment});

  final Dio _dio = Dio();

  final StoycoEnvironment environment;

  Future<Response> getPaged({
    int pageNumber = 1,
    int pageSize = 10,
    String? searchTerm,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl}news/paged',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'searchTerm': searchTerm,
      },
      cancelToken: cancelToken,
    );

    return response;
  }

  //MarkAsViewed
  Future<Response> markAsViewed(String id) async {
    final cancelToken = CancelToken();
    final response = await _dio.post(
      '${environment.baseUrl}news/$id/view',
      data: {
        'id': id,
      },
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<Response> getById(String id) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl}news/$id',
      cancelToken: cancelToken,
    );

    return response;
  }
}
