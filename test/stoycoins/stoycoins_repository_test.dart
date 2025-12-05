import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:stoyco_shared/cache/in_memory_cache_manager.dart';
import 'package:stoyco_shared/stoycoins/stoycoins_repository.dart';
import 'package:stoyco_shared/stoycoins/stoycoins_data_source.dart';
import 'package:stoyco_shared/stoycoins/models/donate.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'stoycoins_repository_test.mocks.dart';

@GenerateMocks([StoycoinsDataSource])
void main() {
  late MockStoycoinsDataSource mockDataSource;
  late StoycoinsRepository repository;

  setUp(() {
    InMemoryCacheManager.resetInstance();
    mockDataSource = MockStoycoinsDataSource();
    repository = StoycoinsRepository(dataSource: mockDataSource);
  });

  group('getBalance', () {
    test('returns BalanceModel on success', () async {
      final userId = 'user123';
      final balanceJson = {
        'userId': userId,
        'availableBalance': 1000,
        'totalBalance': 1000,
        'pendingWithdrawals': 0,
        'currentLevelName': 'Fam',
        'currentLevelCode': 'FAM',
        'currentLevelIconUrl': 'url',
        'pointsToNextLevel': 0,
        'nextLevelName': null,
      };
      when(mockDataSource.getBalance(userId: userId)).thenAnswer(
        (_) async => Response(
          data: balanceJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await repository.getBalance(userId: userId);
      expect(result.isRight, true);
      expect(result.right.userId, userId);
      expect(result.right.availableBalance, 1000);
    });

    test('returns Failure on DioException', () async {
      final userId = 'user123';
      when(mockDataSource.getBalance(userId: userId)).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );
      final result = await repository.getBalance(userId: userId);
      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });
  });

  group('donate', () {
    test('returns DonateResultModel on success', () async {
      final donateModel = DonateModel(senderId: 'a');
      final donateResultJson = {
        'transactionId': 'tx1',
        'newBalance': 900,
        'transactionState': 'APPROVED',
        'currentLevelName': 'Fam',
        'pointsToNextLevel': 0,
        'contextResult': null,
      };
      when(mockDataSource.donate(donateModel)).thenAnswer(
        (_) async => Response(
          data: donateResultJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await repository.donate(donateModel);
      expect(result.isRight, true);
      expect(result.right.transactionId, 'tx1');
    });

    test('returns Failure on DioException', () async {
      final donateModel = DonateModel(senderId: 'a');
      when(mockDataSource.donate(donateModel)).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );
      final result = await repository.donate(donateModel);
      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });
  });

  group('getTransactionDetails', () {
    test('returns PageResult<TransactionModel> on success', () async {
      final userId = 'user123';
      final txJson = {
        'transactionId': 'tx1',
        'userId': userId,
        'points': 100,
        'state': 'APPROVED',
        'source': 'COMMUNITY_FUNDING',
        'referenceId': 'ref1',
        'createdAt': '2025-12-03T21:00:07.426Z',
        'updatedAt': '2025-12-03T21:00:07.426Z',
      };
      final pageResultJson = {
        'items': [txJson],
        'totalCount': 1,
        'page': 1,
        'pageSize': 20,
      };
      when(mockDataSource.getTransactionDetails(
        userId: userId,
        state: null,
        source: null,
        page: null,
        pageSize: null,
      )).thenAnswer(
        (_) async => Response(
          data: pageResultJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await repository.getTransactionDetails(userId: userId);
      expect(result.isRight, true);
      expect(result.right.items?.first.transactionId, 'tx1');
    });

    test('returns Failure on DioException', () async {
      final userId = 'user123';
      when(mockDataSource.getTransactionDetails(
        userId: userId,
        state: null,
        source: null,
        page: null,
        pageSize: null,
      )).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );
      final result = await repository.getTransactionDetails(userId: userId);
      expect(result.isLeft, true);
      expect(result.left, isA<Failure>());
    });
  });
}

