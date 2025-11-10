import 'package:either_dart/either.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/partner/models/market_segment_model.dart';
import 'package:stoyco_shared/partner/models/partner_community_response.dart';
import 'package:stoyco_shared/partner/models/partner_follow_check_response.dart';
import 'package:stoyco_shared/partner/partner_data_source.dart';
import 'package:stoyco_shared/partner/partner_repository.dart';

/// A service that handles all operations related to partners and communities
class PartnerService {
  /// Factory constructor for creating or accessing a singleton instance of [PartnerService].
  ///
  /// The [environment] is required to initialize the service with
  /// the necessary configurations.
  factory PartnerService({required StoycoEnvironment environment}) {
    if (_instance == null) {
      _instance = PartnerService._(environment: environment);
    }
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
}
