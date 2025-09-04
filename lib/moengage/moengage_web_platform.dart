import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter_web/moengage_flutter_web.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';

class MoEngageWebPlatform implements MoEngagePlatform {
  final MoEngageFlutterWeb _moengagePlugin = MoEngageFlutterWeb();
  String? _appId;

  @override
  Future<void> initialize({String? appId}) async {
    _appId = appId;

    print("MoEngage Web: Plataforma inicializada. "
        "App ID (informativo desde Dart): ${_appId ?? 'NO PROPORCIONADO'}. "
        "CRÍTICO: Asegúrate que Moengage.app_id esté configurado en web/index.html.");
  }

  @override
  Future<void> trackCustomEvent(String eventName, Map<String, dynamic>? eventAttributes) async {
    final MoEProperties properties = MoEProperties();

    if (eventAttributes != null) {
      eventAttributes.forEach((key, value) {
        properties.addAttribute(key, value);
      });
    }
    _moengagePlugin.trackEvent(eventName, properties,_appId!);
  }

  @override
  Future<void> identifyUser(String uniqueId) async {
    _moengagePlugin.setUniqueId(uniqueId,_appId!);
  }

  @override
  Future<void> setUserAttribute(String attributeName, dynamic attributeValue) async {
    if (attributeValue is DateTime) {
      _moengagePlugin.setUserAttribute(attributeName, attributeValue.toIso8601String(),_appId!);
    } else {
      _moengagePlugin.setUserAttribute(attributeName, attributeValue,_appId!);
    }
  }

  @override
  Future<void> logout() async {
    _moengagePlugin.logout(_appId!);
  }

  @override
  Future<void> showInAppMessage() async {
    // NO-OP
    throw UnimplementedError(
        "MoEngage Web: showInAppMessage no está implementado en Web.");
  }

  @override
  Future<void> showNudge() async {
    throw UnimplementedError("MoEngage Web: showInAppMessage no está implementado en Web.");
  }
  @override
  Future<void> setUserName(String userName) async {
    _moengagePlugin.setUserName(userName,_appId!);
  }
  @override
  Future<void> setUserEmail(String email) async {
    _moengagePlugin.setEmail(email,_appId!);
  }

  @override
  Future<void> setGender(MoEGender gender) async {
   _moengagePlugin.setGender(gender, _appId!);
  }
  @override
  Future<void> setPhoneNumber(String phoneNumber) async {
    _moengagePlugin.setPhoneNumber(phoneNumber,_appId!);
  }

  @override
  Future<void> setLastName(String lastName) async {
   _moengagePlugin.setLastName(lastName,_appId!);
  }

  @override
  Future<void> setFirstName(String firstName) async {
   _moengagePlugin.setFirstName(firstName,_appId!);
  }
}
