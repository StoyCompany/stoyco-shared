import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/video/models/video_interaction/video_interaction.dart';
import 'package:stoyco_shared/video/models/video_reaction/user_video_reaction.dart';
import 'package:stoyco_shared/video/models/video_player_model.dart';
import 'package:stoyco_shared/video/video_player_ds_impl_v2.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';
import 'package:stoyco_shared/video/video_with_metada/streaming_data.dart';

/// Repository for managing video player interactions.
class VideoPlayerRepositoryV2 {
  /// Creates a [VideoPlayerRepositoryV2] with the given data source and user token.
  VideoPlayerRepositoryV2(this._dataSource, this.userToken);

  /// The data source for video player operations.
  final VideoPlayerDataSourceV2 _dataSource;

  /// The user's authentication token.
  late String userToken;

  /// Updates the user token and propagates it to the data source.
  set token(String token) {
    userToken = token;
    _dataSource.updateUserToken(token);
  }

  /// Handles API calls with error handling.
  Future<Either<Failure, T>> _handleApiCall<T>(
    Future<Response> Function() apiCall,
    T Function(dynamic data) fromJson,
    String errorMessage,
  ) async {
    try {
      final response = await apiCall();
      if (response.statusCode != 200) {
        return Left(
          ExceptionFailure.decode(
            Exception(errorMessage),
          ),
        );
      }
      return Right(fromJson(response.data['data']));
    } on DioException catch (e) {
      return Left(DioFailure.decode(e));
    } on Error catch (e) {
      return Left(ErrorFailure.decode(e));
    } on Exception catch (e) {
      return Left(ExceptionFailure.decode(e));
    }
  }

  /// Handles API calls with error handling for endpoints that return items in a nested structure
  Future<Either<Failure, T>> _handleApiCallWithItems<T>(
    Future<Response> Function() apiCall,
    T Function(dynamic data) fromJson,
    String errorMessage,
  ) async {
    try {
      final response = await apiCall();
      if (response.statusCode != 200) {
        return Left(
          ExceptionFailure.decode(
            Exception(errorMessage),
          ),
        );
      }

      // Access items from data.items instead of just data
      return Right(fromJson(response.data['data']['items']));
    } on DioException catch (e) {
      return Left(DioFailure.decode(e));
    } on Error catch (e) {
      return Left(ErrorFailure.decode(e));
    } on Exception catch (e) {
      return Left(ExceptionFailure.decode(e));
    }
  }

  /// Dislikes a video with the given [videoId].
  Future<Either<Failure, UserVideoReaction>> dislikeVideo(
    String videoId,
    String userId,
  ) async =>
      _handleApiCall(
        () => _dataSource.dislikeVideo(videoId, userId),
        (data) => UserVideoReaction.fromJson(data),
        'Error disliking video',
      );

  /// Retrieves video reactions by [videoId].
  Future<Either<Failure, VideoInteraction>> getVideoReactionsById(
    String videoId,
  ) async =>
      _handleApiCall(
        () => _dataSource.getVideoReactionsById(videoId),
        (data) => VideoInteraction.fromJson(data),
        'Error getting video reactions',
      );

  /// Fetches a list of videos.
  Future<Either<Failure, List<VideoPlayerModel>>> getVideos() async =>
      _handleApiCall(
        () => _dataSource.getVideos(),
        (data) => (data as List)
            .map((item) => VideoPlayerModel.fromJson(item))
            .toList(),
        'Error getting videos',
      );

  /// Likes a video with the given [videoId].
  Future<Either<Failure, UserVideoReaction>> likeVideo(
          String videoId, String userId) async =>
      _handleApiCall(
        () => _dataSource.likeVideo(videoId, userId),
        (data) => UserVideoReaction.fromJson(data),
        'Error liking video',
      );

  /// Retrieves user video interaction data for the given [videoId].
  Future<Either<Failure, UserVideoReaction>> getUserVideoInteractionData(
    String videoId,
  ) async =>
      _handleApiCall(
        () => _dataSource.getUserVideoInteractionData(videoId),
        (data) => UserVideoReaction.fromJson(data),
        'Error getting user video interaction data',
      );

  /// Shares a video with the given [videoId] on the specified [platform].
  Future<Either<Failure, bool>> shareVideo(
    String videoId,
    String platform,
  ) async =>
      _handleApiCall(
        () => _dataSource.shareVideo(videoId, platform),
        (_) => true,
        'Error sharing video',
      );

  /// Views a video with the given [videoId].
  Future<Either<Failure, bool>> viewVideo(
    String videoId,
  ) async =>
      _handleApiCall(
        () => _dataSource.viewVideo(videoId),
        (_) => true,
        'Error viewing video',
      );

  /// Fetches a list of videos with metadata.
  Future<Either<Failure, List<VideoWithMetadata>>>
      getVideosWithMetadata() async => _handleApiCall(
            () => _dataSource.getVideosWithMetadata(),
            (data) => (data as List)
                .map((item) => VideoWithMetadata.fromJson(item))
                .toList(),
            'Error getting videos with metadata',
          );

  /// Fetches videos with filter mode, pagination, and optional userId
  Future<Either<Failure, List<VideoWithMetadata>>> getVideosWithFilter({
    required String filterMode,
    int page = 1,
    int pageSize = 20,
    String? userId,
    String? partnerProfile,
    String? partnerId,
  }) async =>
      _handleApiCallWithItems(
        () => _dataSource.getVideosWithFilter(
          filterMode: filterMode,
          page: page,
          pageSize: pageSize,
          userId: userId,
          partnerProfile: partnerProfile,
          partnerId: partnerId,
        ),
        (data) => (data as List).map((item) {
          final Map<String, dynamic> m = Map<String, dynamic>.from(item as Map);

          // Map fields from feed API to our VideoWithMetadata model
          final streamUrl = m['hlsUrl'] as String? ?? m['mp4Url'] as String?;

          return VideoWithMetadata(
            id: m['contentId'] as String?,
            name: m['title'] as String?,
            videoUrl: m['mp4Url'] as String? ?? m['hlsUrl'] as String?,
            createAt: m['contentCreatedAt'] != null
                ? DateTime.tryParse(m['contentCreatedAt'] as String)
                : null,
            partnerId: m['partnerId'] as String?,
            partnerName: m['partnerName'] as String?,
            isSubscriberOnly: m['isSubscriberOnly'] as bool?,
            isFeaturedContent: m['isFeaturedContent'] as bool?,
            shared: (m['shares'] ?? m['sharedCount']) is int
                ? (m['shares'] ?? m['sharedCount']) as int
                : (m['shares'] ?? m['sharedCount']) != null
                    ? int.tryParse('${m['shares'] ?? m['sharedCount']}')
                    : null,
            followingCO: m['isFollowed'] as bool?,
            likeThisVideo: m['liked'] as bool?,
            likes: (m['likes'] ?? m['likeCount']) is int
                ? (m['likes'] ?? m['likeCount']) as int
                : (m['likes'] ?? m['likeCount']) != null
                    ? int.tryParse('${m['likes'] ?? m['likeCount']}')
                    : null,
            views: (m['views'] ?? m['viewCount']) is int
                ? (m['views'] ?? m['viewCount']) as int
                : (m['views'] ?? m['viewCount']) != null
                    ? int.tryParse('${m['views'] ?? m['viewCount']}')
                    : null,
            description: m['description'] as String?,
            streamingData: streamUrl != null
                ? StreamingData(
                    stream: StreamInfo(url: streamUrl),
                    ready: true,
                  )
                : null,
          );
        }).toList(),
        'Error getting videos with filter',
      );

  /// Fetch featured / explore videos (optional userId, pageSize)
  Future<Either<Failure, List<VideoWithMetadata>>> getFeaturedVideos({
    String? userId,
    int pageSize = 10,
    int page = 1,
    String? partnerProfile,
    String? partnerId,
  }) async =>
      _handleApiCallWithItems(
        () => _dataSource.getFeaturedVideos(
          userId: userId,
          pageSize: pageSize,
          page: page,
          partnerProfile: partnerProfile,
          partnerId: partnerId,
        ),
        (data) => (data as List).map((item) {
          final Map<String, dynamic> m = Map<String, dynamic>.from(item as Map);

          final streamUrl = m['hlsUrl'] as String? ?? m['mp4Url'] as String?;

          return VideoWithMetadata(
            id: m['contentId'] as String?,
            name: m['title'] as String?,
            videoUrl: m['mp4Url'] as String? ?? m['hlsUrl'] as String?,
            createAt: m['contentCreatedAt'] != null
                ? DateTime.tryParse(m['contentCreatedAt'] as String)
                : null,
            partnerId: m['partnerId'] as String?,
            partnerName: m['partnerName'] as String?,
            isSubscriberOnly: m['isSubscriberOnly'] as bool?,
            isFeaturedContent: m['isFeaturedContent'] as bool?,
            shared: (m['shares'] ?? m['sharedCount']) is int
                ? (m['shares'] ?? m['sharedCount']) as int
                : (m['shares'] ?? m['sharedCount']) != null
                    ? int.tryParse('${m['shares'] ?? m['sharedCount']}')
                    : null,
            likes: (m['likes'] ?? m['likeCount']) is int
                ? (m['likes'] ?? m['likeCount']) as int
                : (m['likes'] ?? m['likeCount']) != null
                    ? int.tryParse('${m['likes'] ?? m['likeCount']}')
                    : null,
            views: (m['views'] ?? m['viewCount']) is int
                ? (m['views'] ?? m['viewCount']) as int
                : (m['views'] ?? m['viewCount']) != null
                    ? int.tryParse('${m['views'] ?? m['viewCount']}')
                    : null,
            followingCO: m['isFollowed'] as bool?,
            likeThisVideo: m['liked'] as bool?,
            description: m['description'] as String?,
            streamingData: streamUrl != null
                ? StreamingData(
                    stream: StreamInfo(url: streamUrl),
                    ready: true,
                  )
                : null,
          );
        }).toList(),
        'Error getting featured videos',
      );
}
