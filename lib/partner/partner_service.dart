import 'package:either_dart/either.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/partner/models/market_segment_model.dart';
import 'package:stoyco_shared/partner/models/partner_community_response.dart';
import 'package:stoyco_shared/partner/models/partner_follow_check_response.dart';
import 'package:stoyco_shared/partner/models/partner_content_availability_response.dart';
import 'package:stoyco_shared/partner/partner_data_source.dart';
import 'package:stoyco_shared/partner/partner_repository.dart';

/// A service that handles all operations related to partners and communities
class PartnerService {
  /// Factory constructor for creating or accessing a singleton instance of [PartnerService].
  ///
  /// The [environment] is required to initialize the service with
  /// the necessary configurations.
  factory PartnerService({required StoycoEnvironment environment}) {
    _instance ??= PartnerService._(environment: environment);
    return _instance!;
  }

  /// Private constructor for internal initialization of the [PartnerService].
  ///
  /// This initializes the [_partnerDataSource] and [_partnerRepository] with
  /// the provided [environment].
  PartnerService._({required this.environment}) {
    _partnerDataSource = PartnerDataSource(environment: environment);
    _partnerRepository =
        PartnerRepository(partnerDataSource: _partnerDataSource!);
  }

  /// Singleton instance of the [PartnerService].
  static PartnerService? _instance;

  /// Getter for retrieving the singleton instance of [PartnerService].
  static PartnerService? get instance => _instance;

  /// Resets the singleton instance.
  ///
  /// This is useful for testing purposes to ensure a fresh instance
  /// is created between test cases.
  static void resetInstance() {
    _instance = null;
  }

  /// Environment configuration used for initializing data sources and repositories.
  StoycoEnvironment environment;

  /// Repository responsible for handling partner operations.
  PartnerRepository? _partnerRepository;

  /// Data source used to fetch raw partner data.
  PartnerDataSource? _partnerDataSource;

  /// Retrieves partner and community data by partner ID.
  ///
  /// This method returns a [PartnerCommunityResponse] containing both
  /// Partner and Community information, wrapped in an [Either] to handle
  /// possible [Failure] errors.
  ///
  /// * [partnerId] is the unique identifier of the partner.
  ///
  /// Returns:
  /// - [Either] containing either a [Failure] or a [PartnerCommunityResponse].
  Future<Either<Failure, PartnerCommunityResponse>> getPartnerCommunityById(
    String partnerId,
  ) =>
      _partnerRepository!.getPartnerCommunityById(partnerId);

  /// Retrieves all available market segments.
  ///
  /// Market segments are categories used to classify partners and communities
  /// based on their industry, genre, or focus area (e.g., "Pop", "Regional Mexicano", "Trap Latino").
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a list of [MarketSegmentModel] if successful
  ///
  /// Example:
  /// ```dart
  /// final result = await PartnerService(environment: env).getMarketSegments();
  /// result.fold(
  ///   (failure) => print('Error: $failure'),
  ///   (segments) => segments.forEach((s) => print('${s.id}: ${s.name}')),
  /// );
  /// ```
  Future<Either<Failure, List<MarketSegmentModel>>> getMarketSegments() =>
      _partnerRepository!.getMarketSegments();

  /// Checks if a user follows a partner.
  ///
  /// This method verifies whether the specified user is currently following
  /// the given partner by calling the `/v1/partner/follow/check` endpoint.
  ///
  /// Parameters:
  /// * [userId] is the unique identifier of the user to check.
  /// * [partnerId] is the unique identifier of the partner to check.
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a [PartnerFollowCheckResponse] with follow status if successful
  ///
  /// Example:
  /// ```dart
  /// final result = await PartnerService(environment: env).checkPartnerFollow(
  ///   userId: "user123",
  ///   partnerId: "partner456",
  /// );
  /// result.fold(
  ///   (failure) => print('Error: $failure'),
  ///   (response) => print('Is following: ${response.isFollowing}'),
  /// );
  /// ```
  Future<Either<Failure, PartnerFollowCheckResponse>> checkPartnerFollow({
    required String userId,
    required String partnerId,
  }) =>
      _partnerRepository!.checkPartnerFollow(
        userId: userId,
        partnerId: partnerId,
      );

  /// Retrieves content availability for a partner.
  ///
  /// This method calls the `/v1/feed/partner/{partnerId}/content-availability`
  /// endpoint and returns a set of boolean flags indicating whether different
  /// types of content (news, announcements, events, videos, NFTs, products)
  /// exist for the specified partner.
  ///
  /// Parameters:
  /// * [partnerId] - Unique identifier of the partner.
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a [PartnerContentAvailabilityResponse] if successful
  ///
  /// Example:
  /// ```dart
  /// final result = await PartnerService(environment: env)
  ///   .getPartnerContentAvailability('66f5bd918d77fca522545f01');
  /// result.fold(
  ///   (failure) => print('Error: $failure'),
  ///   (availability) {
  ///     if (availability.data.videos) {
  ///       // show videos section
  ///     }
  ///   },
  /// );
  /// ```
  Future<Either<Failure, PartnerContentAvailabilityResponse>>
      getPartnerContentAvailability(String partnerId) =>
          _partnerRepository!.getPartnerContentAvailability(partnerId);

  // Cache invalidation methods

  /// Invalidates the cached partner community data for a specific partner.
  ///
  /// Call this when partner or community data changes (e.g., after an update).
  ///
  /// Example:
  /// ```dart
  /// PartnerService(environment: env).invalidatePartnerCommunity('partner123');
  /// ```
  void invalidatePartnerCommunity(String partnerId) {
    _partnerRepository?.invalidateCache('partner_community_$partnerId');
  }

  /// Invalidates the cached market segments data.
  ///
  /// Call this when market segments are modified or new ones are added.
  ///
  /// Example:
  /// ```dart
  /// PartnerService(environment: env).invalidateMarketSegments();
  /// ```
  void invalidateMarketSegments() {
    _partnerRepository?.invalidateCache('market_segments');
  }

  /// Invalidates the cached follow status for a specific user and partner.
  ///
  /// Call this after follow/unfollow actions to reflect the latest state.
  ///
  /// Example:
  /// ```dart
  /// PartnerService(environment: env).invalidatePartnerFollow(
  ///   userId: 'user123',
  ///   partnerId: 'partner456',
  /// );
  /// ```
  void invalidatePartnerFollow({
    required String userId,
    required String partnerId,
  }) {
    _partnerRepository?.invalidateCache('partner_follow_${userId}_$partnerId');
  }

  /// Invalidates the cached content availability for a specific partner.
  ///
  /// Call this when partner content is added or removed.
  ///
  /// Example:
  /// ```dart
  /// PartnerService(environment: env).invalidateContentAvailability('partner123');
  /// ```
  void invalidateContentAvailability(String partnerId) {
    _partnerRepository
        ?.invalidateCache('partner_content_availability_$partnerId');
  }

  /// Invalidates all caches related to a specific partner.
  ///
  /// This includes: partner community data, follow status, and content availability.
  /// Useful when performing bulk operations on a partner.
  ///
  /// Example:
  /// ```dart
  /// PartnerService(environment: env).invalidateAllPartnerCaches('partner123');
  /// ```
  void invalidateAllPartnerCaches(String partnerId) {
    _partnerRepository?.invalidateCachePattern(partnerId);
  }

  /// Clears all cached data in the partner service.
  ///
  /// Use with caution - this will force all subsequent calls to fetch fresh data.
  ///
  /// Example:
  /// ```dart
  /// PartnerService(environment: env).clearAllCache();
  /// ```
  void clearAllCache() {
    _partnerRepository?.clearAllCache();
  }
}
