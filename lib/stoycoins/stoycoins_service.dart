import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/errors/error_handling/failure/error.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/stoycoins/models/balance.dart';
import 'package:stoyco_shared/stoycoins/models/donate.dart';
import 'package:stoyco_shared/stoycoins/models/donate_result.dart';
import 'package:stoyco_shared/stoycoins/models/transactions.dart';
import 'package:stoyco_shared/stoycoins/stoycoins_data_source.dart';
import 'package:stoyco_shared/stoycoins/stoycoins_repository.dart';
import 'package:stoyco_shared/stoycoins/user_service.dart';

/// Service for Stoycoins operations: balance, donation, and transactions.
class StoycoinsService {
  /// Factory constructor for singleton instance.
  factory StoycoinsService({required StoycoEnvironment environment,  UserService? userService}) =>
      _instance ??= StoycoinsService._(environment: environment, userService: userService);

  StoycoinsService._({required this.environment,  UserService? userService})
      : _userService = userService ?? UserService() {
    _dataSource = StoycoinsDataSource(environment: environment);
    _repository = StoycoinsRepository(dataSource: _dataSource!);
    _instance = this;
  }

  static StoycoinsService? _instance;
  static StoycoinsService? get instance => _instance;

  StoycoEnvironment environment;
  StoycoinsDataSource? _dataSource;
  StoycoinsRepository? _repository;
  UserService _userService;

  /// Fetches the user's Stoycoins balance.
  ///
  /// If [userId] is null, uses the currently authenticated Firebase user.
  /// Returns an [Either] with [Failure] or [BalanceModel].
  Future<Either<Failure, BalanceModel>> getBalance([String? userId]) async {
    final targetUserId = userId ?? _userService.getCurrentUserId();
    final isAnonymous = !_userService.isUserAuthenticated();
    if (isAnonymous) {
      return Left(ErrorFailure.decode(StateError('User not authenticated')));
    }
    return _repository!.getBalance(userId: targetUserId);
  }

  /// Gets the balance for the currently authenticated Firebase user.
  ///
  /// Returns an [Either] with [Failure] or [BalanceModel].
  Future<Either<Failure, BalanceModel>> getCurrentUserBalance() => getBalance();

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
