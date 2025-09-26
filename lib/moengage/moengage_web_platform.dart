import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';
import 'package:flutter/foundation.dart';

class MoEngageWebPlatform implements MoEngagePlatform {
  late MoEngageFlutter _moengagePlugin;

  @override
  void initialize({required String appId , required String pushToken}) {
    _moengagePlugin = MoEngageFlutter(appId);
    _moengagePlugin.initialise();
    _moengagePlugin.passFCMPushToken(pushToken);
    debugPrint(
        'WebMoEngagePlatform: MoEngageFlutter CREADO e INICIALIZADO con AppID: $appId. Plugin hash: ${_moengagePlugin.hashCode}');
  }

  @override
  void identifyUser(String uniqueId) {
    _moengagePlugin.identifyUser(uniqueId);
  }

  @override
  void trackCustomEvent(
      String eventName, Map<String, dynamic>? eventAttributes) {
    final MoEProperties properties = MoEProperties();

    if (eventAttributes != null) {
      eventAttributes.forEach((key, value) {
        properties.addAttribute(key, value);
      });
    }
    _moengagePlugin.trackEvent(eventName, properties);
  }

  @override
  void setUserAttribute(String name, dynamic value) {
    _moengagePlugin.setUserAttribute(name, value);
  }

  @override
  void logout() => _moengagePlugin.logout();

  @override
  void showInAppMessage() => throw UnimplementedError(
      "MoEngage Web: showInAppMessage no está implementado en Web.");

  @override
  void showNudge() => throw UnimplementedError(
      "MoEngage Web: showInAppMessage no está implementado en Web.");

  @override
  void setUserName(String userName) => _moengagePlugin.setUserName(
        userName,
      );

  @override
  void setUserEmail(String email) => _moengagePlugin.setEmail(
        email,
      );

  @override
  void setGender(MoEGender gender) => _moengagePlugin.setGender(
        gender,
      );

  @override
  void setPhoneNumber(String phoneNumber) =>
      _moengagePlugin.setPhoneNumber(phoneNumber);

  @override
  void setLastName(String lastName) => _moengagePlugin.setLastName(lastName);

  @override
  void setFirstName(String firstName) =>
      _moengagePlugin.setFirstName(firstName);
}
