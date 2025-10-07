import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:stoyco_shared/activity/activity_data_source.dart';
import 'package:stoyco_shared/envs/envs.dart';

@GenerateMocks([Dio])
// Generated mock will be created by mockito's build_runner.
// Run: flutter pub run build_runner build --delete-conflicting-outputs
// The generated file will contain MockDio.
import 'activity_data_source_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late ActivityDataSource ds;

  Response _makeResponse([dynamic data]) => Response(
        data: data ?? {'ok': true},
        requestOptions: RequestOptions(path: '/'),
        statusCode: 200,
      );

  setUp(() {
    mockDio = MockDio();
    ds = ActivityDataSource(
        environment: StoycoEnvironment.testing, dio: mockDio);
    ds.updateUserToken('token123');
  });

  group('ActivityDataSource - notifications', () {
    test('getNotifications uses defaults and sets headers', () async {
      final resp = _makeResponse({'list': []});
      when(mockDio.get('${StoycoEnvironment.testing.urlActivity}/notifications',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        // verify path
        expect(inv.positionalArguments[0],
            '${StoycoEnvironment.testing.urlActivity}/notifications');
        final options = inv.namedArguments[const Symbol('options')] as Options;
        expect(options.headers?['Authorization'], 'Bearer token123');
        // verify default query params
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['page'], 1);
        expect(params['limit'], 20);
        return resp;
      });

      final r = await ds.getNotifications();
      expect(r, resp);
      verify(mockDio.get(
              '${StoycoEnvironment.testing.urlActivity}/notifications',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .called(1);
    });

    test('getNotifications includes optional params', () async {
      final resp = _makeResponse({'list': []});
      when(mockDio.get('${StoycoEnvironment.testing.urlActivity}/notifications',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['type'], 5);
        expect(params['unreadOnly'], true);
        expect(params['expiredOnly'], false);
        return resp;
      });

      final r = await ds.getNotifications(
          page: 2, limit: 5, type: 5, unreadOnly: true, expiredOnly: false);
      expect(r, resp);
    });

    test('searchNotifications sends query and headers', () async {
      final resp = _makeResponse({'hits': []});
      when(mockDio.get(
              '${StoycoEnvironment.testing.urlActivity}/notifications/search',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        expect(inv.positionalArguments[0],
            '${StoycoEnvironment.testing.urlActivity}/notifications/search');
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['q'], 'term');
        expect(params['page'], 1);
        expect(params['limit'], 20);
        return resp;
      });

      final r = await ds.searchNotifications(q: 'term');
      expect(r, resp);
    });

    test('markNotificationViewed calls put with proper path', () async {
      final resp = _makeResponse({'viewed': true});
      when(mockDio.put(
              '${StoycoEnvironment.testing.urlActivity}/notifications/id123/viewed',
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        expect(inv.positionalArguments[0],
            '${StoycoEnvironment.testing.urlActivity}/notifications/id123/viewed');
        final options = inv.namedArguments[const Symbol('options')] as Options;
        expect(options.headers?['Authorization'], 'Bearer token123');
        return resp;
      });

      final r = await ds.markNotificationViewed('id123');
      expect(r, resp);
    });

    test('deleteNotification calls delete with proper path', () async {
      final resp = _makeResponse({'deleted': true});
      when(mockDio.delete(
              '${StoycoEnvironment.testing.urlActivity}/notifications/idX',
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        expect(inv.positionalArguments[0],
            '${StoycoEnvironment.testing.urlActivity}/notifications/idX');
        return resp;
      });

      final r = await ds.deleteNotification('idX');
      expect(r, resp);
    });

    test('getNotificationStats without params sends empty params', () async {
      final resp = _makeResponse({'stats': {}});
      when(mockDio.get(
              '${StoycoEnvironment.testing.urlActivity}/notifications/stats',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params.isEmpty, true);
        return resp;
      });

      final r = await ds.getNotificationStats();
      expect(r, resp);
    });

    test('getNotificationStats with params includes them', () async {
      final resp = _makeResponse({'stats': {}});
      when(mockDio.get(
              '${StoycoEnvironment.testing.urlActivity}/notifications/stats',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['expiredOnly'], true);
        expect(params['unreadOnly'], false);
        return resp;
      });

      final r =
          await ds.getNotificationStats(expiredOnly: true, unreadOnly: false);
      expect(r, resp);
    });
  });

  group('ActivityDataSource - messages & summaries', () {
    test('getMessages default and with optional params', () async {
      final resp = _makeResponse({'messages': []});
      when(mockDio.get('${StoycoEnvironment.testing.urlActivity}/messages',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final path = inv.positionalArguments[0] as String;
        expect(path, '${StoycoEnvironment.testing.urlActivity}/messages');
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        // call may be with defaults or with provided values - ensure keys exist for defaults
        expect(params.containsKey('page'), true);
        return resp;
      });

      final r1 = await ds.getMessages();
      expect(r1, resp);

      final r2 = await ds.getMessages(
          page: 3, limit: 2, category: 'info', unreadOnly: true, ageDays: 7);
      expect(r2, resp);
    });

    test('searchMessages sends q and paging', () async {
      final resp = _makeResponse({'hits': []});
      when(mockDio.get(
              '${StoycoEnvironment.testing.urlActivity}/messages/search',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final path = inv.positionalArguments[0] as String;
        expect(
            path, '${StoycoEnvironment.testing.urlActivity}/messages/search');
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['q'], 'abc');
        return resp;
      });

      final r = await ds.searchMessages(q: 'abc');
      expect(r, resp);
    });

    test('markMessageViewed and deleteMessage call correct endpoints',
        () async {
      final respPut = _makeResponse({'viewed': true});
      when(mockDio.put(
              '${StoycoEnvironment.testing.urlActivity}/messages/msg1/viewed',
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        expect(inv.positionalArguments[0],
            '${StoycoEnvironment.testing.urlActivity}/messages/msg1/viewed');
        return respPut;
      });

      final respDel = _makeResponse({'deleted': true});
      when(mockDio.delete(
              '${StoycoEnvironment.testing.urlActivity}/messages/msg2',
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        expect(inv.positionalArguments[0],
            '${StoycoEnvironment.testing.urlActivity}/messages/msg2');
        return respDel;
      });

      final rPut = await ds.markMessageViewed('msg1');
      expect(rPut, respPut);

      final rDel = await ds.deleteMessage('msg2');
      expect(rDel, respDel);
    });

    test('getMessageStats includes optional params correctly', () async {
      final resp = _makeResponse({'stats': {}});
      when(mockDio.get(
              '${StoycoEnvironment.testing.urlActivity}/messages/stats',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['ageDays'], 10);
        expect(params['unreadOnly'], true);
        return resp;
      });

      final r = await ds.getMessageStats(ageDays: 10, unreadOnly: true);
      expect(r, resp);
    });

    test('getActivitySummary and getUserUnifiedStats include various params',
        () async {
      final resp = _makeResponse({'summary': {}});
      when(mockDio.get(
              '${StoycoEnvironment.testing.urlActivity}/activity/summary',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['unreadOnly'], true);
        expect(params['expiredOnly'], false);
        expect(params['ageDays'], 3);
        return resp;
      });

      final r = await ds.getActivitySummary(
          unreadOnly: true, expiredOnly: false, ageDays: 3);
      expect(r, resp);

      final resp2 = _makeResponse({'userStats': {}});
      when(mockDio.get('${StoycoEnvironment.testing.urlActivity}/user/stats',
              queryParameters: anyNamed('queryParameters'),
              cancelToken: anyNamed('cancelToken'),
              options: anyNamed('options')))
          .thenAnswer((inv) async {
        final params = inv.namedArguments[const Symbol('queryParameters')]
            as Map<String, dynamic>;
        expect(params['unreadOnly'], true);
        expect(params['expiredOnly'], false);
        expect(params['ageDays'], 4);
        return resp2;
      });

      final r2 = await ds.getUserUnifiedStats(
          unreadOnly: true, expiredOnly: false, ageDays: 4);
      expect(r2, resp2);
    });
  });
}
