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

  /// Dislikes a video with the given [videoId].
  Future<Either<Failure, UserVideoReaction>> dislikeVideo(
    String videoId,
  ) async =>
      _handleApiCall(
        () => _dataSource.dislikeVideo(videoId),
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
  Future<Either<Failure, UserVideoReaction>> likeVideo(String videoId) async =>
      _handleApiCall(
        () => _dataSource.likeVideo(videoId),
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

  /// Fetches a list of videos with metadata.
  Future<Either<Failure, List<VideoWithMetadata>>>
      getVideosWithMetadata() async => _handleApiCall(
            () => _dataSource.getVideosWithMetadata(),
            (data) => (data as List)
                .map((item) => VideoWithMetadata.fromJson(item))
                .toList(),
            'Error getting videos with metadata',
          );
}
