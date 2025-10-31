import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:stoyco_shared/coach_mark/errors/exception.dart';

import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/utils/utils.dart';
import 'package:stoyco_shared/video/models/video_interaction/video_interaction.dart';
import 'package:stoyco_shared/video/models/video_reaction/user_video_reaction.dart';
import 'package:stoyco_shared/video/models/video_player_model.dart';
import 'dart:collection';

import 'package:stoyco_shared/video/video_player_ds_impl_v2.dart';
import 'package:stoyco_shared/video/video_player_repository_v2.dart';
import 'package:stoyco_shared/video/video_with_metada/video_with_metadata.dart';

/// Service responsible for managing video playback and reactions.
///
/// Example:
/// ```dart
/// var videoService = VideoPlayerService(environment: StoycoEnvironment.development);
/// var videos = await videoService.getVideos();
/// ```
class VideoPlayerService {
  /// Private constructor for [VideoPlayerService].
  ///
  /// [environment] The environment configuration.
  /// [userToken] The user token.
  /// [functionToUpdateToken] Function to update the user token.
  VideoPlayerService._({
    this.environment = StoycoEnvironment.development,
    this.userToken = '',
    this.functionToUpdateToken,
  }) {
    _dataSource = VideoPlayerDataSourceV2(environment);
    _repository = VideoPlayerRepositoryV2(_dataSource!, userToken);
    _repository!.token = userToken;
    _dataSource!.updateUserToken(userToken);
  }

  /// Factory constructor for [VideoPlayerService].
  ///
  /// [environment] The environment configuration.
  /// [userToken] The user token.
  /// [functionToUpdateToken] Function to update the user token.
  ///
  /// Example:
  /// ```dart
  /// var videoService = VideoPlayerService(userToken: 'abc123');
  /// ```
  factory VideoPlayerService({
    StoycoEnvironment environment = StoycoEnvironment.development,
    String userToken = '',
    Future<String?>? functionToUpdateToken,
  }) {
    _instance = VideoPlayerService._(
      environment: environment,
      userToken: userToken,
      functionToUpdateToken: functionToUpdateToken,
    );

    return _instance!;
  }

  /// Function to update the user token.
  Future<String?>? functionToUpdateToken;

  /// Sets the function to update the user token.
  ///
  /// [function] The function to set.
  void setFunctionToUpdateToken(Future<String?> function) {
    functionToUpdateToken = function;
    userToken = '';
  }

  /// The environment configuration used for initializing data sources and repositories.
  StoycoEnvironment environment;

  /// Repository responsible for handling video operations.
  VideoPlayerRepositoryV2? _repository;

  /// Data source used to fetch raw video data.
  VideoPlayerDataSourceV2? _dataSource;

  static VideoPlayerService? _instance;

  /// Singleton instance of [VideoPlayerService].
  static VideoPlayerService? get instance => _instance;

  /// Cache for storing [UserVideoReaction] with timestamps.
  final Map<String, _CachedVideoInteraction> _reactionCache = HashMap();

  /// The token of the user.
  String userToken = '';

  /// Sets the user token and updates the repository and data source.
  ///
  /// [token] The new user token.
  set token(String token) {
    userToken = token;
    _repository!.token = token;
    _dataSource!.updateUserToken(token);
  }

  /// Verifies the user token and updates it if necessary.
  ///
  /// Throws an exception if token update fails.
  Future<void> verifyToken() async {
    if (userToken.isEmpty) {
      if (functionToUpdateToken == null) {
        throw FunctionToUpdateTokenNotSetException();
      }

      final String? newToken = await functionToUpdateToken!;

      if (newToken != null && newToken.isNotEmpty) {
        userToken = newToken;
        _repository!.token = newToken;
      } else {
        throw EmptyUserTokenException('Failed to update token');
      }
    }
  }

  /// Retrieves a list of videos.
  ///
  /// Returns an [Either] containing a [Failure] or a list of [VideoPlayerModel].
  ///
  /// Example:
  /// ```dart
  /// var videos = await videoService.getVideos();
  /// ```
  Future<Either<Failure, List<VideoPlayerModel>>> getVideos() async =>
      await _repository!.getVideos();

  /// Retrieves video reactions by video ID, with an option to force update.
  ///
  /// [videoId] The ID of the video.
  /// [force] Whether to force update the reactions.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> getVideoReactionsById(
    String videoId, {
    bool force = false,
  }) async {
    try {
      await verifyToken();

      final cached = _reactionCache[videoId];
      final now = DateTime.now();

      if (!force &&
          cached != null &&
          now.difference(cached.timestamp).inSeconds < 30) {
        return Right(cached.reaction);
      }

      final result = await _repository!.getVideoReactionsById(videoId);
      result.fold(
        (_) {},
        (reaction) {
          _reactionCache[videoId] = _CachedVideoInteraction(reaction, now);
        },
      );
      return result;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Likes a video.
  ///
  /// [videoId] The ID of the video to like.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> likeVideo({
    required String videoId,
    required String userId,
  }) async {
    try {
      await verifyToken();
      final result = await _repository!.likeVideo(
        videoId,
        userId,
      );
      final reaction = await _handleReaction(result);
      return reaction;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Dislikes a video.
  ///
  /// [videoId] The ID of the video to dislike.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> dislikeVideo({
    required String videoId,
    required String userId,
  }) async {
    try {
      await verifyToken();
      final result = await _repository!.dislikeVideo(
        videoId,
        userId,
      );
      final reaction = await _handleReaction(result);
      return reaction;
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Handles the reaction after liking or disliking a video.
  ///
  /// [result] The result of the like or dislike operation.
  ///
  /// Returns an [Either] containing a [Failure] or a [VideoInteraction].
  Future<Either<Failure, VideoInteraction>> _handleReaction(
    Either<Failure, UserVideoReaction> result,
  ) async =>
      result.fold(
        (left) => Left(left),
        (reaction) => getVideoReactionsById(
          reaction.videoId!,
          force: true,
        ),
      );

  /// Shares a video.
  ///
  /// [videoId] The ID of the video to share.
  ///
  /// Returns an [Either] containing a [Failure] or a boolean indicating success.
  Future<Either<Failure, bool>> shareVideo({
    required String videoId,
    bool isWeb = false,
  }) async {
    try {
      await verifyToken();
      return await _repository!.shareVideo(
        videoId,
        !isWeb ? getPlatform() : 'web',
      );
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Views a video.
  ///
  /// [videoId] The ID of the video to view.
  ///
  /// Returns an [Either] containing a [Failure] or a boolean indicating success.
  Future<Either<Failure, bool>> viewVideo({
    required String videoId,
  }) async {
    try {
      return await _repository!.viewVideo(
        videoId,
      );
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves user video interaction data.
  ///
  /// [videoId] The ID of the video.
  ///
  /// Returns an [Either] containing a [Failure] or a [UserVideoReaction].
  Future<Either<Failure, UserVideoReaction>> getUserVideoInteractionData({
    required String videoId,
  }) async {
    try {
      await verifyToken();
      return await _repository!.getUserVideoInteractionData(videoId);
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves a list of videos with metadata.
  ///
  /// Returns an [Either] containing a [Failure] or a list of [VideoWithMetadata].
  Future<Either<Failure, List<VideoWithMetadata>>>
      getVideosWithMetadata() async {
    try {
      return await _repository!.getVideosWithMetadata();
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves videos with filter mode, pagination, and optional userId
  ///
  /// [filterMode] The filter mode (e.g., 'Featured', 'ForYou')
  /// [page] The page number (default: 1)
  /// [pageSize] The number of items per page (default: 20)
  /// [userId] Optional user ID for personalized content
  /// [partnerProfile] Optional partner profile filter (Music, Sport, Brand)
  ///
  /// Returns an [Either] containing a [Failure] or a list of [VideoWithMetadata].
  Future<Either<Failure, List<VideoWithMetadata>>> getVideosWithFilter({
    required String filterMode,
    int page = 1,
    int pageSize = 20,
    String? userId,
    String? partnerProfile,
  }) async {
    try {
      return await _repository!.getVideosWithFilter(
        filterMode: filterMode,
        page: page,
        pageSize: pageSize,
        userId: userId,
        partnerProfile: partnerProfile,
      );
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Retrieves featured / explore videos.
  ///
  /// [userId] Optional user id to personalize results.
  /// [pageSize] Number of items to fetch (default: 10).
  /// [page] Page number for pagination (default: 1).
  /// [partnerProfile] Optional partner profile filter (Music, Sport, Brand).
  Future<Either<Failure, List<VideoWithMetadata>>> getFeaturedVideos({
    String? userId,
    int pageSize = 10,
    int page = 1,
    String? partnerProfile,
  }) async {
    try {
      return await _repository!.getFeaturedVideos(
        userId: userId,
        pageSize: pageSize,
        page: page,
        partnerProfile: partnerProfile,
      );
    } catch (e) {
      StoyCoLogger.error('Error: $e');
      return Left(ExceptionFailure.decode(Exception(e)));
    }
  }

  /// Determines the platform the app is running on.
  ///
  /// Returns a string representing the platform.
  String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  /// Resets the service to its initial state.
  ///
  /// This method:
  /// - Clears the user token
  /// - Removes the function to update token
  /// - Updates the datasource to clear the token
  void reset() {
    userToken = '';
    functionToUpdateToken = null;
    _repository?.token = '';
    _dataSource
        ?.updateUserToken(''); // IMPORTANT: Clear token in datasource too!
  }
}

/// Cached video interaction with a timestamp.
class _CachedVideoInteraction {
  /// Creates a new cached video interaction.
  ///
  /// [reaction] The video interaction reaction.
  /// [timestamp] The time the reaction was cached.
  _CachedVideoInteraction(this.reaction, this.timestamp);
  final VideoInteraction reaction;
  final DateTime timestamp;
}
