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
    String? communityOwnerId,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl()}news/paged',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'searchTerm': searchTerm,
        'communityOwnerId': communityOwnerId,
      },
      cancelToken: cancelToken,
    );

    return response;
  }

  /// Fetches paginated feed data for a given feed type (default: 'news').
  ///
  /// [feedType] specifies the type of feed to fetch (e.g. 'news', 'announcements').
  /// All other parameters are passed as query parameters.
  Future<Response> getPagedFeed({
    int pageNumber = 1,
    int pageSize = 20,
    String? partnerId,
    String? userId,
    String? partnerProfile,
    bool? onlyNew,
    int? newDays = 30,
    bool? hideSubscriberOnlyIfNotSubscribed,
    String? ct,
    String feedType = 'news',
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl()}feed/explore/content?contentType=$feedType&partnerId=$partnerId',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'partnerId': partnerId,
        'userId': userId,
        'partnerProfile': partnerProfile,
        'onlyNew': onlyNew,
        'newDays': newDays,
        'hideSubscriberOnlyIfNotSubscribed': hideSubscriberOnlyIfNotSubscribed,
        'ct': ct,
      },
      cancelToken: cancelToken,
    );
    return response;
  }


  Future<Response> getPagedFeedEvents({
    int pageNumber = 1,
    int pageSize = 20,
    String? partnerId,
    String? userId,
    String? partnerProfile,
    bool? onlyNew,
    int? newDays = 30,
    bool? hideSubscriberOnlyIfNotSubscribed,
    String? ct,
    String feedType = '3',
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl()}feed/events?partnerId=$partnerId&eventType=$feedType',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'partnerId': partnerId,
        'userId': userId,
        'partnerProfile': partnerProfile,
        'onlyNew': onlyNew,
        'newDays': newDays,
        'hideSubscriberOnlyIfNotSubscribed': hideSubscriberOnlyIfNotSubscribed,
        'ct': ct,
      },
      cancelToken: cancelToken,
    );
    return response;
  }



  //MarkAsViewed
  Future<Response> markAsViewed(String id) async {
    final cancelToken = CancelToken();
    final response = await _dio.post(
      '${environment.baseUrl()}news/$id/view',
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
      '${environment.baseUrl()}news/$id',
      cancelToken: cancelToken,
    );

    return response;
  }
}
