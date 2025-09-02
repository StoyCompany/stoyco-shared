import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';
import 'package:stoyco_shared/moengage/platform_locator.dart'
if (dart.library.io) 'platform_locator_mobile.dart'
if (dart.library.html) 'platform_locator_web.dart';

class MoEngageService {
  MoEngageService._internal([MoEngagePlatform? platform]) {
    _platform = platform ?? getMoEngagePlatform();
    debugPrint('MoEngageService: Plataforma seleccionada por el compilador.');
  }
  static MoEngageService? _instance;
  late final MoEngagePlatform _platform;

  static MoEngageService get instance {
    _instance ??= MoEngageService._internal();
    return _instance!;
  }

  static Future<MoEngageService> init({required String appId, MoEngagePlatform? platform}) async {
    _instance = MoEngageService._internal(platform);
    await _instance!._platform.initialize(appId: appId);
    return _instance!;
  }

  Future<void> setUniqueId(String uniqueId) async {
    await _platform.identifyUser(uniqueId);
  }

  Future<void> trackCustomEvent(String eventName, {Map<String, Object>? attributes}) async {
    await _platform.trackCustomEvent(eventName, attributes);
  }

  Future<void> setUserAttribute(String name, dynamic value) async {
    await _platform.setUserAttribute(name, value);
  }

  Future<void> showInAppMessage() async {
    await _platform.showInAppMessage();
  }

  Future<void> showNudge() async {
    await _platform.showNudge();
  }

  Future<void> logout() async {
    await _platform.logout();
  }

  Future<void> setUserName(String userName) async {
    await _platform.setUserName(userName);
  }
  Future<void> setUserEmail(String email) async {
    await _platform.setUserEmail(email);
  }

  Future<void> setGender(String gender) async {
    final MoEGender genderEnum = stringToGender(gender);
    await _platform.setGender(genderEnum);
  }

  Future<void> setPhoneNumber(String phoneNumber) async {
    await _platform.setPhoneNumber(phoneNumber);
  }

  Future<void> setLastName(String lastName) async {
    await _platform.setLastName(lastName);
  }

  Future<void> setFirstName(String firstName) async {
    await _platform.setFirstName(firstName);
  }
  MoEGender stringToGender(String gender) {
    switch (gender.toLowerCase()) {
      case 'masculino':
        return MoEGender.male;
      case 'femenino':
        return MoEGender.female;
      case 'otro':
        return MoEGender.other;
      default:
        return MoEGender.other;
    }
  }

}
