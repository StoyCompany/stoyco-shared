import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/cache/repository_cache_mixin.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/stoycoins/models/balance.dart';
import 'package:stoyco_shared/stoycoins/models/donate.dart';
import 'package:stoyco_shared/stoycoins/models/donate_result.dart';
import 'package:stoyco_shared/stoycoins/models/transactions.dart';
import 'package:stoyco_shared/stoycoins/stoycoins_data_source.dart';

/// Repository for Stoycoins operations: balance, donation, and transactions.
class StoycoinsRepository with RepositoryCacheMixin {
  StoycoinsRepository({required StoycoinsDataSource dataSource}) : _dataSource = dataSource;

  final StoycoinsDataSource _dataSource;

  /// Cached for 3 minutes (user balance).
  Future<Either<Failure, BalanceModel>> getBalance({required String userId}) async =>
      cachedCall<BalanceModel>(
        key: 'stoycoins_balance_$userId',
        ttl: const Duration(minutes: 3),
        fetcher: () async {
          try {
            final response = await _dataSource.getBalance(userId: userId);
            final balance = BalanceModel.fromJson(response.data as Map<String, dynamic>);
            return Right(balance);
          } on DioException catch (error) {
            return Left(DioFailure.decode(error));
          } on Error catch (error) {
            return Left(ErrorFailure.decode(error));
          } on Exception catch (error) {
            return Left(ExceptionFailure.decode(error));
          }
        },
      );

  /// Sends a donation transaction.
  ///
  /// Returns an [Either] with [Failure] on the left or [DonateResultModel] on the right.
  /// Example:
  /// ```dart
  /// final result = await repository.donate(donateModel);
  /// ```
  Future<Either<Failure, DonateResultModel>> donate(DonateModel donateModel) async {
    try {
      final response = await _dataSource.donate(donateModel);
      final result = DonateResultModel.fromJson(response.data as Map<String, dynamic>);
      return Right(result);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }

  /// Fetches a paginated list of Stoycoins transactions for a user.
  ///
  /// Returns an [Either] with [Failure] on the left or [PageResult<TransactionModel>] on the right.
  /// Example:
  /// ```dart
  /// final result = await repository.getTransactionDetails(userId: 'user123', page: 1, pageSize: 20);
  /// ```
  Future<Either<Failure, PageResult<TransactionModel>>> getTransactionDetails({
    required String userId,
    String? state,
    String? source,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _dataSource.getTransactionDetails(
        userId: userId,
        state: state,
        source: source,
        page: page,
        pageSize: pageSize,
      );
      final pageResult = PageResult<TransactionModel>.fromJson(
        response.data,
        (item) => TransactionModel.fromJson(item as Map<String, dynamic>),
      );
      return Right(pageResult);
    } on DioException catch (error) {
      return Left(DioFailure.decode(error));
    } on Error catch (error) {
      return Left(ErrorFailure.decode(error));
    } on Exception catch (error) {
      return Left(ExceptionFailure.decode(error));
    }
  }
}
