import 'package:flutter/foundation.dart';
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

  Future<void> logout() async {
    await _platform.logout();
  }
}