import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/partner/models/market_segment_model.dart';
import 'package:stoyco_shared/partner/models/partner_community_response.dart';
import 'package:stoyco_shared/partner/models/partner_follow_check_response.dart';
import 'package:stoyco_shared/partner/models/partner_content_availability_response.dart';
import 'package:stoyco_shared/partner/partner_data_source.dart';

class PartnerRepository with RepositoryCacheMixin {
  PartnerRepository({required PartnerDataSource partnerDataSource})
      : _partnerDataSource = partnerDataSource;

  final PartnerDataSource _partnerDataSource;

  /// Gets partner and community data by partner ID
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a [PartnerCommunityResponse] if successful
  ///
  /// Cached for 10 minutes.
  Future<Either<Failure, PartnerCommunityResponse>> getPartnerCommunityById(
    String partnerId,
  ) async =>
      cachedCall<PartnerCommunityResponse>(
        key: 'partner_community_$partnerId',
        ttl: const Duration(minutes: 10),
        fetcher: () async {
          try {
            final response =
                await _partnerDataSource.getPartnerCommunityById(partnerId);

            final partnerCommunityResponse =
                PartnerCommunityResponse.fromJson(response.data);

            return Right(partnerCommunityResponse);
          } on DioException catch (error) {
            return Left(DioFailure.decode(error));
          } on Error catch (error) {
            return Left(ErrorFailure.decode(error));
          } on Exception catch (error) {
            return Left(ExceptionFailure.decode(error));
          }
        },
      );

  /// Gets all available market segments.
  ///
  /// Market segments are categories used to classify partners and communities.
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a list of [MarketSegmentModel] if successful
  ///
  /// Cached for 30 minutes (static data, rarely changes).
  Future<Either<Failure, List<MarketSegmentModel>>> getMarketSegments() async =>
      cachedCall<List<MarketSegmentModel>>(
        key: 'market_segments',
        ttl: const Duration(minutes: 30),
        fetcher: () async {
          try {
            final response = await _partnerDataSource.getMarketSegments();

            final segments = (response.data as List)
                .map((json) =>
                    MarketSegmentModel.fromJson(json as Map<String, dynamic>))
                .toList();

            return Right(segments);
          } on DioException catch (error) {
            return Left(DioFailure.decode(error));
          } on Error catch (error) {
            return Left(ErrorFailure.decode(error));
          } on Exception catch (error) {
            return Left(ExceptionFailure.decode(error));
          }
        },
      );

  /// Checks if a user follows a partner.
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a [PartnerFollowCheckResponse] if successful
  ///
  /// Cached for 2 minutes (user state can change).
  Future<Either<Failure, PartnerFollowCheckResponse>> checkPartnerFollow({
    required String userId,
    required String partnerId,
  }) async =>
      cachedCall<PartnerFollowCheckResponse>(
        key: 'partner_follow_${userId}_$partnerId',
        ttl: const Duration(minutes: 2),
        fetcher: () async {
          try {
            final response = await _partnerDataSource.checkPartnerFollow(
              userId: userId,
              partnerId: partnerId,
            );

            final followCheckResponse =
                PartnerFollowCheckResponse.fromJson(response.data);

            return Right(followCheckResponse);
          } on DioException catch (error) {
            return Left(DioFailure.decode(error));
          } on Error catch (error) {
            return Left(ErrorFailure.decode(error));
          } on Exception catch (error) {
            return Left(ExceptionFailure.decode(error));
          }
        },
      );

  /// Gets content availability flags for a partner.
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a [PartnerContentAvailabilityResponse] if successful
  ///
  /// Cached for 5 minutes (dynamic content list).
  Future<Either<Failure, PartnerContentAvailabilityResponse>>
      getPartnerContentAvailability(String partnerId) async =>
          cachedCall<PartnerContentAvailabilityResponse>(
            key: 'partner_content_availability_$partnerId',
            ttl: const Duration(minutes: 5),
            fetcher: () async {
              try {
                final response = await _partnerDataSource
                    .getPartnerContentAvailability(partnerId);
                final availabilityResponse =
                    PartnerContentAvailabilityResponse.fromJson(response.data);
                return Right(availabilityResponse);
              } on DioException catch (error) {
                return Left(DioFailure.decode(error));
              } on Error catch (error) {
                return Left(ErrorFailure.decode(error));
              } on Exception catch (error) {
                return Left(ExceptionFailure.decode(error));
              }
            },
          );
}
