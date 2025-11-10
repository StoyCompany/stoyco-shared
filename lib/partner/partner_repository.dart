import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/partner/models/market_segment_model.dart';
import 'package:stoyco_shared/partner/models/partner_community_response.dart';
import 'package:stoyco_shared/partner/models/partner_follow_check_response.dart';
import 'package:stoyco_shared/partner/partner_data_source.dart';

class PartnerRepository {
  PartnerRepository({required PartnerDataSource partnerDataSource})
      : _partnerDataSource = partnerDataSource;

  final PartnerDataSource _partnerDataSource;

  /// Gets partner and community data by partner ID
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a [PartnerCommunityResponse] if successful
  Future<Either<Failure, PartnerCommunityResponse>> getPartnerCommunityById(
    String partnerId,
  ) async {
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
  }

  /// Gets all available market segments.
  ///
  /// Market segments are categories used to classify partners and communities.
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a list of [MarketSegmentModel] if successful
  Future<Either<Failure, List<MarketSegmentModel>>> getMarketSegments() async {
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
  }

  /// Checks if a user follows a partner.
  ///
  /// Returns an [Either] with:
  /// - [Left] containing a [Failure] if the request fails
  /// - [Right] containing a [PartnerFollowCheckResponse] if successful
  Future<Either<Failure, PartnerFollowCheckResponse>> checkPartnerFollow({
    required String userId,
    required String partnerId,
  }) async {
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
  }
}
