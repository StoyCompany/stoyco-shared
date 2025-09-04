import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter_web/moengage_flutter_web.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';

class MoEngageWebPlatform implements MoEngagePlatform {
  final MoEngageFlutterWeb _moengagePlugin = MoEngageFlutterWeb();
  String? _appId;

  @override
  void initialize({String? appId}) {
    _appId = appId;

    print("MoEngage Web: Plataforma inicializada. "
        "App ID (informativo desde Dart): ${_appId ?? 'NO PROPORCIONADO'}. "
        "CRÍTICO: Asegúrate que Moengage.app_id esté configurado en web/index.html.");
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
    _moengagePlugin.trackEvent(eventName, properties, _appId!);
  }

  @override
  void identifyUser(String uniqueId) =>
      _moengagePlugin.setUniqueId(uniqueId, _appId!);

  @override
  void setUserAttribute(String attributeName, dynamic attributeValue) {
    if (attributeValue is DateTime) {
      _moengagePlugin.setUserAttribute(
          attributeName, attributeValue.toIso8601String(), _appId!);
    } else {
      _moengagePlugin.setUserAttribute(attributeName, attributeValue, _appId!);
    }
  }

  @override
  void logout() => _moengagePlugin.logout(_appId!);

  @override
  void showInAppMessage() => throw UnimplementedError(
      "MoEngage Web: showInAppMessage no está implementado en Web.");

  @override
  void showNudge() => throw UnimplementedError(
      "MoEngage Web: showInAppMessage no está implementado en Web.");

  @override
  void setUserName(String userName) =>
      _moengagePlugin.setUserName(userName, _appId!);

  @override
  void setUserEmail(String email) => _moengagePlugin.setEmail(email, _appId!);

  @override
  void setGender(MoEGender gender) =>
      _moengagePlugin.setGender(gender, _appId!);

  @override
  void setPhoneNumber(String phoneNumber) =>
      _moengagePlugin.setPhoneNumber(phoneNumber, _appId!);

  @override
  void setLastName(String lastName) =>
      _moengagePlugin.setLastName(lastName, _appId!);

  @override
  void setFirstName(String firstName) =>
      _moengagePlugin.setFirstName(firstName, _appId!);
}
