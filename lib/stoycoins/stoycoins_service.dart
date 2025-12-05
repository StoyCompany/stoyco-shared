import 'package:either_dart/either.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/stoycoins/models/balance.dart';
import 'package:stoyco_shared/stoycoins/models/donate.dart';
import 'package:stoyco_shared/stoycoins/models/donate_result.dart';
import 'package:stoyco_shared/stoycoins/models/transactions.dart';
import 'package:stoyco_shared/stoycoins/stoycoins_data_source.dart';
import 'package:stoyco_shared/stoycoins/stoycoins_repository.dart';

/// Service for Stoycoins operations: balance, donation, and transactions.
class StoycoinsService {
  /// Factory constructor for singleton instance.
  factory StoycoinsService({required StoycoEnvironment environment}) =>
      _instance ??= StoycoinsService._(environment: environment);

  StoycoinsService._({required this.environment}) {
    _dataSource = StoycoinsDataSource(environment: environment);
    _repository = StoycoinsRepository(dataSource: _dataSource!);
    _instance = this;
  }

  static StoycoinsService? _instance;
  static StoycoinsService? get instance => _instance;

  StoycoEnvironment environment;
  StoycoinsDataSource? _dataSource;
  StoycoinsRepository? _repository;

  /// Fetches the user's Stoycoins balance.
  ///
  /// Returns an [Either] with [Failure] or [BalanceModel].
  Future<Either<Failure, BalanceModel>> getBalance(String userId) =>
      _repository!.getBalance(userId: userId);

  /// Sends a donation transaction.
  ///
  /// Returns an [Either] with [Failure] or [DonateResultModel].
  Future<Either<Failure, DonateResultModel>> donate(DonateModel donateModel) =>
      _repository!.donate(donateModel);

  /// Fetches a Stoycoins transaction  for a user.
  ///
  /// Returns an [Either] with [Failure] or [PageResult<TransactionModel>].
  Future<Either<Failure, PageResult<TransactionModel>>> getTransactionDetails({
    required String userId,
    String? state,
    String? source,
    int? page,
    int? pageSize,
  }) => _repository!.getTransactionDetails(
    userId: userId,
    state: state,
    source: source,
    page: page,
    pageSize: pageSize,
  );
}

