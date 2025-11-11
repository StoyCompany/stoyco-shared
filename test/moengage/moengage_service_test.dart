// test/moengage/moengage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';
import 'package:stoyco_shared/moengage/moengage_service.dart';
import 'moengage_service_test.mocks.dart';

@GenerateMocks([MoEngagePlatform])
void main() {
  late MockMoEngagePlatform mockPlatform;

  setUp(() {
    mockPlatform = MockMoEngagePlatform();
  });

  test('init calls initialize on platform', ()  {
    when(mockPlatform.initialize(appId: 'testAppId', pushToken: '')).thenAnswer((_)  async {});
     MoEngageService.init(appId: 'testAppId', platform: mockPlatform, pushToken: '');
    verify(mockPlatform.initialize(appId: 'testAppId', pushToken: '')).called(1);
  });


  test('setUniqueId delegates to platform', ()  {
     MoEngageService.init(appId: 'testAppId', platform: mockPlatform, pushToken: '');
    when(mockPlatform.identifyUser('user123')).thenAnswer((_) async {});
     MoEngageService.instance.setUniqueId('user123');
    verify(mockPlatform.identifyUser('user123')).called(1);
  });

  test('trackCustomEvent delegates to platform', ()  {
    final eventName = 'event';
    final attributes = {'key': 'value'};
    when(mockPlatform.trackCustomEvent(eventName, attributes)).thenAnswer((_) async {});
     MoEngageService.init(appId: 'testAppId', platform: mockPlatform, pushToken: '');
     MoEngageService.instance.trackCustomEvent(eventName, attributes: attributes);
    verify(mockPlatform.trackCustomEvent(eventName, attributes)).called(1);
  });

  test('setUserAttribute delegates to platform', ()  {
    when(mockPlatform.setUserAttribute('attr', 'val')).thenAnswer((_) async {});
     MoEngageService.init(appId: 'testAppId', platform: mockPlatform, pushToken: '');
     MoEngageService.instance.setUserAttribute('attr', 'val');
    verify(mockPlatform.setUserAttribute('attr', 'val')).called(1);
  });

  test('logout delegates to platform', ()  {
    when(mockPlatform.logout()).thenAnswer((_) async {});
     MoEngageService.init(appId: 'testAppId', platform: mockPlatform, pushToken: '');
     MoEngageService.instance.logout();
    verify(mockPlatform.logout()).called(1);
  });
}