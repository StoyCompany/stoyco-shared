import 'package:dio/dio.dart';
import 'package:stoyco_shared/announcement/models/announcement_participation/announcement_participation.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/utils/filter_request.dart';

/// A data source class for handling announcement-related API operations.
///
/// This class provides methods to fetch, view, and participate in announcements
/// by interfacing with the announcement backend API.
///
/// Example:
/// ```dart
/// final dataSource = AnnouncementDataSource(environment: environment);
/// final response = await dataSource.getPaged(filters: FilterRequest());
/// ```
class AnnouncementDataSource {
  /// Creates an instance of [AnnouncementDataSource].
  ///
  /// Requires a [StoycoEnvironment] to determine the appropriate API endpoints.
  AnnouncementDataSource({required this.environment});

  final Dio _dio = Dio();

  /// The environment configuration used for API endpoints.
  final StoycoEnvironment environment;

  /// Retrieves a paginated list of announcements based on provided filters.
  ///
  /// [filters] - The filter criteria to apply to the announcement search.
  ///
  /// Returns a [Response] containing the paginated announcement data.
  ///
  /// Example:
  /// ```dart
  /// final filters = FilterRequest(
  ///   page: 1,
  ///   pageSize: 10,
  ///   filter: {'status': 'active'}
  /// );
  /// final response = await dataSource.getPaged(filters: filters);
  /// final announcements = response.data;
  /// ```
  Future<Response> getPaged({required FilterRequest filters}) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlAnnouncement}announcement',
      queryParameters: FilterRequestHelper.toQueryMap(filters),
      cancelToken: cancelToken,
    );

    return response;
  }

  /// Retrieves a specific announcement by its ID.
  ///
  /// [announcementId] - The unique identifier of the announcement to retrieve.
  ///
  /// Returns a [Response] containing the announcement data.
  ///
  /// Example:
  /// ```dart
  /// final announcementId = '12345';
  /// final response = await dataSource.getById(announcementId: announcementId);
  /// final announcementDetails = response.data;
  /// ```
  Future<Response> getById({required String announcementId}) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlAnnouncement}announcement/$announcementId',
      cancelToken: cancelToken,
    );

    return response;
  }

  /// Registers a participation in a specific announcement.
  ///
  /// [announcementId] - The unique identifier of the announcement to participate in.
  /// [data] - The participation details including user information and submission data.
  ///
  /// Returns a [Response] containing the result of the participation request.
  ///
  /// Example:
  /// ```dart
  /// final announcementId = '12345';
  /// final participation = AnnouncementParticipation(
  ///   userId: 'user123',
  ///   submissionData: {'answer': 'My submission'},
  /// );
  /// final response = await dataSource.participate(
  ///   announcementId: announcementId,
  ///   data: participation,
  /// );
  /// final result = response.data;
  /// ```
  Future<Response> participate({
    required String announcementId,
    required AnnouncementParticipation data,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.post(
      '${environment.urlAnnouncement}announcement/$announcementId/publications',
      data: data.toJson(),
      cancelToken: cancelToken,
    );

    return response;
  }

  /// Retrieves the leadership board for a specific announcement.
  ///
  /// [announcementId] - The unique identifier of the announcement
  /// [pageNumber] - The page number for pagination
  /// [pageSize] - The number of items per page
  ///
  /// Returns a [Response] containing the leadership board data.
  ///
  /// Example:
  /// ```dart
  /// final response = await dataSource.getLeadershipBoard(
  ///   announcementId: '67dc8ae8b51fdb2a8a7ec637',
  ///   pageNumber: 1,
  ///   pageSize: 5,
  /// );
  /// final leaderboardData = response.data;
  /// ```
  Future<Response> getLeadershipBoard({
    required String announcementId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.urlAnnouncement}announcement/$announcementId/leadership-board',
      queryParameters: {
        'page_number': pageNumber,
        'page_size': pageSize,
      },
      cancelToken: cancelToken,
    );

    return response;
  }
}
