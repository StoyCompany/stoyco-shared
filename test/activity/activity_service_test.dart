import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:stoyco_shared/activity/activity_service.dart';
import 'package:stoyco_shared/activity/activity_repository.dart';
import 'package:stoyco_shared/activity/activity_data_source.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';
import 'package:stoyco_shared/notification/model/notification_model.dart';
import 'package:stoyco_shared/activity/models/message_model.dart';
import 'package:stoyco_shared/activity/models/message_stats_model.dart';
import 'package:stoyco_shared/activity/models/activity_summary_model.dart';
import 'package:stoyco_shared/activity/models/user_unified_stats_model.dart';
import 'package:stoyco_shared/errors/error_handling/failure/exception.dart';
import 'package:stoyco_shared/errors/error_handling/failure/failure.dart';
import 'activity_service_test.mocks.dart';

// Provide a dummy value for Mockito when it needs a return value while
// capturing unstubbed interactions. This avoids MissingDummyValueError for
// the complex generic return type used by getNotifications.
void _provideMocks() {
  provideDummy<Either<Failure, PageResult<NotificationModel>>>(
    Right(
      PageResult<NotificationModel>(
        pageNumber: 1,
        pageSize: 10,
        items: <NotificationModel>[],
      ),
    ),
  );
  provideDummy<Either<Failure, PageResult<MessageModel>>>(
    Right(
      PageResult<MessageModel>(
        pageNumber: 1,
        pageSize: 10,
        items: <MessageModel>[],
      ),
    ),
  );
  provideDummy<Either<Failure, MessageStatsModel>>(
    Right(
      MessageStatsModel(
        id: '1',
        userId: 'u',
        totalNotifs: 0,
        unreadNotifs: 0,
        readNotifs: 0,
        categoryBreakdown: {},
        lastUpdated: '',
      ),
    ),
  );
  provideDummy<Either<Failure, bool>>(Right(true));
  provideDummy<Either<Failure, ActivitySummaryModel>>(
    Right(
      ActivitySummaryModel(
        id: '1',
        unreadNotifications: 0,
        unreadMessages: 0,
        totalUnread: 0,
        lastUpdated: '',
      ),
    ),
  );
  provideDummy<Either<Failure, UserUnifiedStatsModel>>(
    Right(
      UserUnifiedStatsModel(
        id: '1',
        totalMessages: 0,
        unreadMessages: 0,
        totalNotifications: 0,
        unreadNotifications: 0,
        totalItems: 0,
        totalUnread: 0,
        lastUpdated: '',
      ),
    ),
  );
}

@GenerateMocks([ActivityRepository, ActivityDataSource])
void main() {
  late MockActivityRepository mockRepo;
  late MockActivityDataSource mockDs;
  late ActivityService service;
  setUp(() {
    mockRepo = MockActivityRepository();
    mockDs = MockActivityDataSource();
    ActivityService.resetInstance();
    _provideMocks();
  });

  group('verifyToken', () {
    test('returns Left when functionToUpdateToken not set', () async {
      service = ActivityService.forTest(
        repository: mockRepo,
        dataSource: mockDs,
        userToken: '',
      );
      final res = await service.verifyToken();
      expect(res.isLeft, true);
    });

    test('reuses in-flight refresh', () async {
      // function that waits a bit and returns token
      var calls = 0;
      Future<String?> fn() async {
        calls++;
        await Future.delayed(Duration(milliseconds: 10));
        return 'new-token';
      }

      service = ActivityService.forTest(
        repository: mockRepo,
        dataSource: mockDs,
        userToken: '',
        functionToUpdateToken: fn,
      );

      // Start two concurrent verifications
      final f1 = service.verifyToken();
      final f2 = service.verifyToken();
      final results = await Future.wait([f1, f2]);
      expect(results[0].isRight, true);
      expect(results[1].isRight, true);
      expect(calls, 1); // only one refresh executed
    });
  });

  test('withAuth retries once on thrown DioException with 401', () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async => 'refreshed',
    );

    // First call: throw DioException with 401
    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 401,
        ),
      ),
    );

    // After refresh, return a successful PageResult
    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenAnswer(
      (_) async => Right(
        PageResult<NotificationModel>(
          pageNumber: 1,
          pageSize: 10,
          items: <NotificationModel>[],
        ),
      ),
    );

    final res = await service.getNotifications(1, 10);
    expect(res.isRight, true);
  });

  test('withAuth returns original failure when refresh fails', () async {
    // functionToUpdateToken returns null -> refresh fails
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async => null,
    );

    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenAnswer(
      (_) async => Left(ExceptionFailure.decode(Exception('unauth'))),
    );

    final res = await service.getNotifications(1, 10);
    expect(res.isLeft, true);
  });

  test('token setter updates data source and dio headers', () async {
    final dio = Dio();
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      dio: dio,
      userToken: '',
    );

    // token setter should update data source and dio headers
    service.token = 'abc-123';
    verify(mockDs.updateUserToken('abc-123')).called(1);
    expect(dio.options.headers['Authorization'], 'Bearer abc-123');
  });

  test(
      'withAuth retries once when repository returns Left(DioFailure with 401)',
      () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async => 'refreshed',
    );

    final dioExc = DioException(
      requestOptions: RequestOptions(path: '/'),
      response: Response(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 401,
      ),
    );

    // First call returns Left(DioFailure with 401), second call returns Right
    var call = 0;
    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenAnswer((_) async {
      call++;
      if (call == 1) return Left(DioFailure.decode(dioExc));
      return Right(
        PageResult<NotificationModel>(
          pageNumber: 1,
          pageSize: 10,
          items: <NotificationModel>[],
        ),
      );
    });

    final res = await service.getNotifications(1, 10);
    expect(res.isRight, true);
  });

  test(
      'withAuth returns original failure when repository returns non-auth DioFailure',
      () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async => 'refreshed',
    );

    final dioExc = DioException(
      requestOptions: RequestOptions(path: '/'),
      response: Response(
        requestOptions: RequestOptions(path: '/'),
        statusCode: 500,
      ),
    );

    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenAnswer((_) async => Left(DioFailure.decode(dioExc)));

    final res = await service.getNotifications(1, 10);
    expect(res.isLeft, true);
    // statusCode should be available on the DioFailure inside the Left
    expect((res.left as DioFailure).statusCode, 500);
  });

  test('wrappers call repository methods and return Right on success',
      () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: 'token-xyz',
      functionToUpdateToken: () async => 'ignored',
    );

    // stub multiple repository methods to return simple successful values
    when(
      mockRepo.getMessages(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        category: anyNamed('category'),
        unreadOnly: anyNamed('unreadOnly'),
        ageDays: anyNamed('ageDays'),
      ),
    ).thenAnswer(
      (_) async => Right(
        PageResult<MessageModel>(
          pageNumber: 1,
          pageSize: 10,
          items: <MessageModel>[],
        ),
      ),
    );

    when(
      mockRepo.searchMessages(
        any,
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer(
      (_) async => Right(
        PageResult<MessageModel>(
          pageNumber: 1,
          pageSize: 10,
          items: <MessageModel>[],
        ),
      ),
    );

    when(mockRepo.markMessageViewed(any)).thenAnswer((_) async => Right(true));
    when(mockRepo.deleteMessage(any)).thenAnswer((_) async => Right(true));
    when(
      mockRepo.getMessageStats(
        ageDays: anyNamed('ageDays'),
        unreadOnly: anyNamed('unreadOnly'),
      ),
    ).thenAnswer(
      (_) async => Right(
        MessageStatsModel(
          id: '1',
          userId: 'u',
          totalNotifs: 0,
          unreadNotifs: 0,
          readNotifs: 0,
          categoryBreakdown: {},
          lastUpdated: '',
        ),
      ),
    );

    when(
      mockRepo.getActivitySummary(
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
        ageDays: anyNamed('ageDays'),
      ),
    ).thenAnswer(
      (_) async => Right(
        ActivitySummaryModel(
          id: '1',
          unreadNotifications: 0,
          unreadMessages: 0,
          totalUnread: 0,
          lastUpdated: '',
        ),
      ),
    );

    when(
      mockRepo.getUserUnifiedStats(
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
        ageDays: anyNamed('ageDays'),
      ),
    ).thenAnswer(
      (_) async => Right(
        UserUnifiedStatsModel(
          id: '1',
          totalMessages: 0,
          unreadMessages: 0,
          totalNotifications: 0,
          unreadNotifications: 0,
          totalItems: 0,
          totalUnread: 0,
          lastUpdated: '',
        ),
      ),
    );

    final r1 = await service.getMessages(1, 10);
    expect(r1.isRight, true);

    final r2 = await service.searchMessages('q', 1, 10);
    expect(r2.isRight, true);

    final r3 = await service.markMessageViewed('id');
    expect(r3.isRight, true);

    final r4 = await service.deleteMessage('id');
    expect(r4.isRight, true);

    final r5 = await service.getMessageStats();
    expect(r5.isRight, true);

    final r6 = await service.getActivitySummary();
    expect(r6.isRight, true);

    final r7 = await service.getUserUnifiedStats();
    expect(r7.isRight, true);
  });

  test('real factory constructs and honors initial token', () async {
    ActivityService.resetInstance();
    final svc = ActivityService(userToken: 'initial');
    // verify that instance is created and token is set (verifyToken will short-circuit)
    final verify = await svc.verifyToken();
    expect(verify.isRight, true);
    ActivityService.resetInstance();
  });

  test('_startTokenRefresh returns Left when functionToUpdateToken throws',
      () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async {
        throw Exception('fail');
      },
    );
    final res = await service.verifyToken();
    expect(res.isLeft, true);
    expect(res.left.message.contains('fail'), true);
  });

  test('withAuth returns Left when action throws non-Dio exception', () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async => 'refreshed',
    );
    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenThrow(Exception('boom'));

    final res = await service.getNotifications(1, 10);
    expect(res.isLeft, true);
    expect(res.left.message.contains('boom'), true);
  });

  test('withAuth returns Left when action returns non-Dio Failure', () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async => 'refreshed',
    );
    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenAnswer((_) async => Left(ExceptionFailure.decode(Exception('x'))));

    final res = await service.getNotifications(1, 10);
    expect(res.isLeft, true);
    expect(res.left is ExceptionFailure, true);
  });

  test(
      'withAuth (thrown DioException) returns original failure when refresh fails',
      () async {
    // Simulate functionToUpdateToken that returns a token on the first
    // call (so initial verifyToken succeeds) and then returns null on
    // the second call (so the refresh attempt fails).
    var calls = 0;
    Future<String?> fn() async {
      calls++;
      if (calls == 1) return 'initial-refreshed';
      return null;
    }

    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: fn,
    );

    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 401,
        ),
      ),
    );

    final res = await service.getNotifications(1, 10);
    expect(res.isLeft, true);
    expect((res.left as DioFailure).statusCode, 401);
  });

  test(
      'withAuth retries once then returns ExceptionFailure when retry throws non-Dio exception',
      () async {
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      userToken: '',
      functionToUpdateToken: () async => 'refreshed',
    );

    var call = 0;
    when(
      mockRepo.getNotifications(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
        type: anyNamed('type'),
        unreadOnly: anyNamed('unreadOnly'),
        expiredOnly: anyNamed('expiredOnly'),
      ),
    ).thenAnswer((_) async {
      call++;
      if (call == 1)
        throw DioException(
          requestOptions: RequestOptions(path: '/'),
          response: Response(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 401,
          ),
        );
      throw Exception('retryFailed');
    });

    final res = await service.getNotifications(1, 10);
    expect(res.isLeft, true);
    expect(res.left.message.contains('retryFailed'), true);
  });

  test(
      'token setter empty removes Authorization header and updates data source',
      () async {
    final dio = Dio();
    service = ActivityService.forTest(
      repository: mockRepo,
      dataSource: mockDs,
      dio: dio,
      userToken: 'initial',
    );

    // set to empty should remove header and update data source
    service.token = '';
    verify(mockDs.updateUserToken('')).called(1);
    expect(dio.options.headers.containsKey('Authorization'), false);
  });
}
