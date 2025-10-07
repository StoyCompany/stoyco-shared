import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stoyco_shared/activity/activity_repository.dart';
import 'package:stoyco_shared/activity/activity_data_source.dart';
import 'package:stoyco_shared/activity/models/message_model.dart';
import 'package:stoyco_shared/notification/model/notification_model.dart';
import 'package:stoyco_shared/activity/models/notification_stats_model.dart';
import 'package:stoyco_shared/models/page_result/page_result.dart';

import 'activity_repository_test.mocks.dart';

@GenerateMocks([ActivityDataSource])
void main() {
  late MockActivityDataSource mockDs;
  late ActivityRepository repo;

  setUp(() {
    mockDs = MockActivityDataSource();
    repo = ActivityRepository(dataSource: mockDs);
  });

  Response _respWithData(Map<String, dynamic> data) => Response(
        data: data,
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
      );

  group('getNotifications', () {
    test('parses page result on success', () async {
      final json = {
        'data': [
          {
            'type': 'n',
            'id': '1',
            'attributes': {'id': '1', 'title': 't'}
          }
        ],
        'meta': {
          'pagination': {'page': 1, 'limit': 10, 'total': 1, 'pages': 1}
        }
      };
      when(mockDs.getNotifications(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              type: anyNamed('type'),
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly')))
          .thenAnswer((_) async => _respWithData(json));

      final res = await repo.getNotifications();
      expect(res.isRight, true);
      final page = res.right;
      expect(page, isA<PageResult<NotificationModel>>());
      final items = (page as dynamic).items as List?;
      expect(items?.length, 1);
      expect(page.pageNumber, 1);
    });

    test('returns DioFailure on DioException', () async {
      when(mockDs.getNotifications(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              type: anyNamed('type'),
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));

      final res = await repo.getNotifications();
      expect(res.isLeft, true);
    });

    test('returns ErrorFailure on Error thrown', () async {
      when(mockDs.getNotifications(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              type: anyNamed('type'),
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly')))
          .thenThrow(Error());
      final res = await repo.getNotifications();
      expect(res.isLeft, true);
    });

    test('returns ExceptionFailure on Exception thrown', () async {
      when(mockDs.getNotifications(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              type: anyNamed('type'),
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly')))
          .thenThrow(Exception('boom'));
      final res = await repo.getNotifications();
      expect(res.isLeft, true);
    });
  });

  group('searchNotifications', () {
    test('parses page result', () async {
      final json = {
        'data': [],
        'meta': {
          'pagination': {'page': 1, 'limit': 20, 'total': 0, 'pages': 0}
        }
      };
      when(mockDs.searchNotifications(q: 'q', page: 1, limit: 20))
          .thenAnswer((_) async => _respWithData(json));

      final res = await repo.searchNotifications('q');
      expect(res.isRight, true);
    });

    test('returns Left on DioException', () async {
      when(mockDs.searchNotifications(
              q: anyNamed('q'),
              page: anyNamed('page'),
              limit: anyNamed('limit')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final res = await repo.searchNotifications('q');
      expect(res.isLeft, true);
    });

    test('returns Left on Error', () async {
      when(mockDs.searchNotifications(
              q: anyNamed('q'),
              page: anyNamed('page'),
              limit: anyNamed('limit')))
          .thenThrow(Error());
      final res = await repo.searchNotifications('q');
      expect(res.isLeft, true);
    });

    test('returns Left on Exception', () async {
      when(mockDs.searchNotifications(
              q: anyNamed('q'),
              page: anyNamed('page'),
              limit: anyNamed('limit')))
          .thenThrow(Exception('x'));
      final res = await repo.searchNotifications('q');
      expect(res.isLeft, true);
    });
  });

  group('mark/delete notification', () {
    test('markNotificationViewed returns true on 200', () async {
      when(mockDs.markNotificationViewed('id')).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: '/'), statusCode: 200));
      final res = await repo.markNotificationViewed('id');
      expect(res.isRight, true);
      expect(res.right, true);
    });

    test('deleteNotification returns true on 204', () async {
      when(mockDs.deleteNotification('id')).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: '/'), statusCode: 204));
      final res = await repo.deleteNotification('id');
      expect(res.isRight, true);
      expect(res.right, true);
    });

    test('markNotificationViewed handles exceptions', () async {
      when(mockDs.markNotificationViewed('id'))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final res = await repo.markNotificationViewed('id');
      expect(res.isLeft, true);
    });

    test('deleteNotification handles exceptions', () async {
      when(mockDs.deleteNotification('id')).thenThrow(Exception('x'));
      final res = await repo.deleteNotification('id');
      expect(res.isLeft, true);
    });
  });

  group('getNotificationStats', () {
    test('returns model when data present', () async {
      final json = {
        'data': {
          'type': 'n',
          'id': '1',
          'attributes': {
            'id': '1',
            'userId': 'u',
            'total': 1,
            'unread': 0,
            'read': 1,
            'typeBreakdown': {},
            'lastUpdated': 'x'
          }
        }
      };
      when(mockDs.getNotificationStats(
              expiredOnly: anyNamed('expiredOnly'),
              unreadOnly: anyNamed('unreadOnly')))
          .thenAnswer((_) async => _respWithData(json));
      final res = await repo.getNotificationStats();
      expect(res.isRight, true);
      expect(res.right, isA<NotificationStatsModel>());
    });

    test('returns failure when data null (model decode error)', () async {
      when(mockDs.getNotificationStats(
              expiredOnly: anyNamed('expiredOnly'),
              unreadOnly: anyNamed('unreadOnly')))
          .thenAnswer((_) async => _respWithData({}));
      final res = await repo.getNotificationStats();
      expect(res.isLeft, true);
    });

    test('getNotificationStats handles DioException', () async {
      when(mockDs.getNotificationStats(
              expiredOnly: anyNamed('expiredOnly'),
              unreadOnly: anyNamed('unreadOnly')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final res = await repo.getNotificationStats();
      expect(res.isLeft, true);
    });

    test('getNotificationStats handles Exception', () async {
      when(mockDs.getNotificationStats(
              expiredOnly: anyNamed('expiredOnly'),
              unreadOnly: anyNamed('unreadOnly')))
          .thenThrow(Exception('x'));
      final res = await repo.getNotificationStats();
      expect(res.isLeft, true);
    });
  });

  group('messages', () {
    test('getMessages parses page result', () async {
      final json = {
        'data': [
          {
            'type': 'm',
            'id': '1',
            'attributes': {'id': '1', 'title': 't'}
          }
        ],
        'meta': {
          'pagination': {'page': 1, 'limit': 10, 'total': 1, 'pages': 1}
        }
      };
      when(mockDs.getMessages(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              category: anyNamed('category'),
              unreadOnly: anyNamed('unreadOnly'),
              ageDays: anyNamed('ageDays')))
          .thenAnswer((_) async => _respWithData(json));

      final res = await repo.getMessages();
      expect(res.isRight, true);
      final page = res.right;
      expect(page, isA<PageResult<MessageModel>>());
      final items = (page as dynamic).items as List?;
      expect(items?.length, 1);
    });

    test('searchMessages returns page result', () async {
      final json = {
        'data': [],
        'meta': {
          'pagination': {'page': 1, 'limit': 20, 'total': 0, 'pages': 0}
        }
      };
      when(mockDs.searchMessages(q: 'q', page: 1, limit: 20))
          .thenAnswer((_) async => _respWithData(json));
      final res = await repo.searchMessages('q');
      expect(res.isRight, true);
    });

    test('searchMessages handles DioException/Error/Exception', () async {
      when(mockDs.searchMessages(
              q: anyNamed('q'),
              page: anyNamed('page'),
              limit: anyNamed('limit')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final r1 = await repo.searchMessages('q');
      expect(r1.isLeft, true);
      when(mockDs.searchMessages(
              q: anyNamed('q'),
              page: anyNamed('page'),
              limit: anyNamed('limit')))
          .thenThrow(Error());
      final r2 = await repo.searchMessages('q');
      expect(r2.isLeft, true);
      when(mockDs.searchMessages(
              q: anyNamed('q'),
              page: anyNamed('page'),
              limit: anyNamed('limit')))
          .thenThrow(Exception('x'));
      final r3 = await repo.searchMessages('q');
      expect(r3.isLeft, true);
    });

    test('markMessageViewed and deleteMessage return bools', () async {
      when(mockDs.markMessageViewed('id')).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: '/'), statusCode: 200));
      when(mockDs.deleteMessage('id')).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(path: '/'), statusCode: 200));
      final r1 = await repo.markMessageViewed('id');
      final r2 = await repo.deleteMessage('id');
      expect(r1.isRight, true);
      expect(r2.isRight, true);
    });

    test('markMessageViewed handles errors', () async {
      when(mockDs.markMessageViewed('id')).thenThrow(Error());
      final r = await repo.markMessageViewed('id');
      expect(r.isLeft, true);
    });

    test('deleteMessage handles errors', () async {
      when(mockDs.deleteMessage('id'))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final r = await repo.deleteMessage('id');
      expect(r.isLeft, true);
    });

    test('getMessageStats returns model or empty', () async {
      final json = {
        'data': {
          'type': 'm',
          'id': '1',
          'attributes': {
            'id': '1',
            'userId': 'u1',
            'totalNotifs': 1,
            'unreadNotifs': 0,
            'readNotifs': 1,
            'categoryBreakdown': {},
            'lastUpdated': 'x'
          }
        }
      };
      when(mockDs.getMessageStats(
              ageDays: anyNamed('ageDays'), unreadOnly: anyNamed('unreadOnly')))
          .thenAnswer((_) async => _respWithData(json));
      final res = await repo.getMessageStats();
      expect(res.isRight, true);

      when(mockDs.getMessageStats(
              ageDays: anyNamed('ageDays'), unreadOnly: anyNamed('unreadOnly')))
          .thenAnswer((_) async => _respWithData({}));
      final res2 = await repo.getMessageStats();
      expect(res2.isLeft, true);
    });

    test('getMessageStats catches exceptions', () async {
      when(mockDs.getMessageStats(
              ageDays: anyNamed('ageDays'), unreadOnly: anyNamed('unreadOnly')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final r1 = await repo.getMessageStats();
      expect(r1.isLeft, true);
      when(mockDs.getMessageStats(
              ageDays: anyNamed('ageDays'), unreadOnly: anyNamed('unreadOnly')))
          .thenThrow(Error());
      final r2 = await repo.getMessageStats();
      expect(r2.isLeft, true);
    });
  });

  group('summaries and user stats', () {
    test('getActivitySummary returns model or empty', () async {
      final json = {
        'data': {
          'type': 'a',
          'id': '1',
          'attributes': {
            'id': '1',
            'unreadNotifications': 1,
            'unreadMessages': 2,
            'totalUnread': 3,
            'lastUpdated': 'now'
          }
        }
      };
      when(mockDs.getActivitySummary(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenAnswer((_) async => _respWithData(json));
      final res = await repo.getActivitySummary();
      expect(res.isRight, true);

      when(mockDs.getActivitySummary(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenAnswer((_) async => _respWithData({}));
      final res2 = await repo.getActivitySummary();
      expect(res2.isLeft, true);
    });

    test('getActivitySummary handles errors', () async {
      when(mockDs.getActivitySummary(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final r1 = await repo.getActivitySummary();
      expect(r1.isLeft, true);
      when(mockDs.getActivitySummary(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenThrow(Exception('x'));
      final r2 = await repo.getActivitySummary();
      expect(r2.isLeft, true);
    });

    test('getUserUnifiedStats returns model or empty', () async {
      final json = {
        'data': {
          'type': 'u',
          'id': '1',
          'attributes': {
            'id': '1',
            'totalMessages': 1,
            'unreadMessages': 0,
            'totalNotifications': 2,
            'unreadNotifications': 1,
            'totalItems': 3,
            'totalUnread': 1,
            'lastUpdated': 'now'
          }
        }
      };
      when(mockDs.getUserUnifiedStats(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenAnswer((_) async => _respWithData(json));
      final res = await repo.getUserUnifiedStats();
      expect(res.isRight, true);

      when(mockDs.getUserUnifiedStats(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenAnswer((_) async => _respWithData({}));
      final res2 = await repo.getUserUnifiedStats();
      expect(res2.isLeft, true);
    });

    test('getUserUnifiedStats handles errors', () async {
      when(mockDs.getUserUnifiedStats(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/')));
      final r1 = await repo.getUserUnifiedStats();
      expect(r1.isLeft, true);
      when(mockDs.getUserUnifiedStats(
              unreadOnly: anyNamed('unreadOnly'),
              expiredOnly: anyNamed('expiredOnly'),
              ageDays: anyNamed('ageDays')))
          .thenThrow(Error());
      final r2 = await repo.getUserUnifiedStats();
      expect(r2.isLeft, true);
    });
  });
}
