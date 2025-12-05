import 'dart:async';

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

/// Service for Stoycoins operations: balance, donation, and transactions.
class StoycoinsService {
  /// Factory constructor for singleton instance.
  factory StoycoinsService(
          {required StoycoEnvironment environment,
          FirebaseAuth? firebaseAuth}) =>
      _instance ??= StoycoinsService._(
          environment: environment, firebaseAuth: firebaseAuth);

  StoycoinsService._({required this.environment, FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance {
    _dataSource = StoycoinsDataSource(environment: environment);
    _repository = StoycoinsRepository(dataSource: _dataSource!);
    _instance = this;
    _initializeBalanceStream();
  }

  static StoycoinsService? _instance;

  static StoycoinsService? get instance => _instance;

  StoycoEnvironment environment;
  StoycoinsDataSource? _dataSource;
  StoycoinsRepository? _repository;
  final FirebaseAuth _firebaseAuth;

  /// Cached current balance model
  BalanceModel? _currentBalance;

  /// Stream controller for balance updates
  final StreamController<BalanceModel> _balanceStreamController =
      StreamController<BalanceModel>.broadcast();

  StreamSubscription<User?>? _authSubscription;

  /// Stream of authentication state changes from FirebaseAuth.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Stream that emits balance updates when the user is logged in and availableBalance > 0.
  ///
  /// This stream automatically fetches the balance when authentication state changes.
  /// Only emits when [BalanceModel.availableBalance] is greater than 0.
  ///
  /// Example:
  /// ```dart
  /// StoycoinsService.instance?.balanceStream.listen((balance) {
  ///   print('Available balance: ${balance.availableBalance}');
  /// });
  /// ```
  Stream<BalanceModel> get balanceStream => _balanceStreamController.stream;

  /// Initializes the balance stream listener based on authentication state.
  void _initializeBalanceStream() {
    _authSubscription = authStateChanges.listen((user) async {
      if (user != null) {
        await _fetchAndEmitBalance();
      } else {
        _currentBalance = null;
      }
    });
  }

  /// Fetches the balance and emits it to the stream if availableBalance > 0.
  Future<void> _fetchAndEmitBalance() async {
    final result = await getCurrentUserBalance();
    result.fold(
      (failure) {

      },
      (balance) {
        _currentBalance = balance;
        if (balance.availableBalance != null && balance.availableBalance! > 0) {
          _balanceStreamController.add(balance);
        }
      },
    );
  }

  /// Fetches the user's Stoycoins balance.
  ///
  /// If [userId] is null, uses the currently authenticated Firebase user.
  /// Updates the cached balance and emits to stream if availableBalance > 0.
  /// Returns an [Either] with [Failure] or [BalanceModel].
  Future<Either<Failure, BalanceModel>> getBalance([String? userId]) async {
    final targetUserId = userId ?? _firebaseAuth.currentUser?.uid;
    if (targetUserId == null) {
      return Left(ErrorFailure.decode(StateError('User not authenticated')));
    }
    final result = await _repository!.getBalance(userId: targetUserId);

    if (result.isRight && targetUserId == _firebaseAuth.currentUser?.uid) {
      _currentBalance = result.right;
      if (result.right.availableBalance != null &&
          result.right.availableBalance! > 0) {
        _balanceStreamController.add(result.right);
      }
    }

    return result;
  }

  /// Gets the balance for the currently authenticated Firebase user.
  /// Returns an [Either] with [Failure] or [BalanceModel].
  Future<Either<Failure, BalanceModel>> getCurrentUserBalance() => getBalance();

  /// Sends a donation transaction.
  /// Returns an [Either] with [Failure] or [DonateResultModel].
  Future<Either<Failure, DonateResultModel>> donate(DonateModel donateModel) =>
      _repository!.donate(donateModel);

  /// Fetches a Stoycoins transaction for a user.
  /// Returns an [Either] with [Failure] or [PageResult<TransactionModel>].
  Future<Either<Failure, PageResult<TransactionModel>>> getTransactionDetails({
    required String userId,
    String? state,
    String? source,
    int? page,
    int? pageSize,
  }) =>
      _repository!.getTransactionDetails(
        userId: userId,
        state: state,
        source: source,
        page: page,
        pageSize: pageSize,
      );

  /// Gets the available balance for the currently authenticated Firebase user from cache.
  /// Returns the cached available balance as [int], or null if not available.
  /// This method does NOT make additional API calls; it returns the cached value.
  ///
  /// To fetch a fresh balance, use [getCurrentUserBalance] or listen to [balanceStream].
  int? get currentUserAvailableBalance => _currentBalance?.availableBalance;

  /// Disposes the service and cleans up resources.
  ///
  /// Cancels the authentication subscription and closes the balance stream.
  /// Should be called when the service is no longer needed.
  void dispose() {
    _authSubscription?.cancel();
    _balanceStreamController.close();
  }

  /// Resets the singleton instance for testing purposes.
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }
}
