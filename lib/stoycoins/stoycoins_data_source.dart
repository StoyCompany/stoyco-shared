import 'package:dio/dio.dart';
import 'package:stoyco_shared/envs/envs.dart';
import 'package:stoyco_shared/stoycoins/models/donate.dart';

/// Data source for Stoycoins operations: balance and donation.
class StoycoinsDataSource {
  StoycoinsDataSource({required this.environment, required Dio dio})
      : _dio = dio;

  final Dio _dio;
  final StoycoEnvironment environment;

  /// User token for authenticated requests
  late String userToken;

  /// Update user token used in Authorization header
  void updateUserToken(String newUserToken) {
    userToken = newUserToken;
  }

  /// Headers for authenticated requests
  Map<String, String> _getHeaders() => {
        'Authorization': 'Bearer $userToken',
      };

  /// Fetches the user's Stoycoins balance.
  ///
  /// Returns a [Response] containing the balance data.
  /// Example:
  /// ```dart
  /// final response = await dataSource.getBalance(userId: 'user123');
  /// ```
  Future<Response> getBalance({required String userId}) async {
    final cancelToken = CancelToken();
    final response = await _dio.get(
      '${environment.baseUrl()}stoycoins/balance',
      queryParameters: {
        'userId': userId,
      },
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  /// Sends a donation transaction.
  ///
  /// [donateModel] is the payload for the donation.
  /// Returns a [Response] containing the donation result.
  /// Example:
  /// ```dart
  /// final response = await dataSource.donate(donateModel);
  /// ```
  Future<Response> donate(DonateModel donateModel) async {
    final cancelToken = CancelToken();
    final response = await _dio.post(
      '${environment.baseUrl()}stoycoins/donate',
      data: donateModel.toJson(),
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }

  /// Fetches a list of Stoycoins transactions for a user.
  ///
  /// [userId] is required. You can optionally filter by [state], [source], [page], and [pageSize].
  /// Returns a [Response] containing the transaction data.
  /// Example:
  /// ```dart
  /// final response = await dataSource.getTransactions(userId: 'user123', page: 1, pageSize: 20);
  /// ```
  Future<Response> getTransactionDetails({
    required String userId,
    String? state,
    String? source,
    int? page,
    int? pageSize,
  }) async {
    final cancelToken = CancelToken();
    final queryParameters = {
      'userId': userId,
      if (state != null) 'state': state,
      if (source != null) 'source': source,
      if (page != null) 'page': page,
      if (pageSize != null) 'pageSize': pageSize,
    };
    final response = await _dio.get(
      '${environment.baseUrl()}stoycoins/transactions',
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: Options(headers: _getHeaders()),
    );
    return response;
  }
}
