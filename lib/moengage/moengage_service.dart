import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_geofence/moengage_geofence.dart';
import 'package:stoyco_shared/moengage/moengage_mobile_platform.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';
import 'package:stoyco_shared/moengage/platform_locator.dart'
    if (dart.library.io) 'platform_locator_mobile.dart'
    if (dart.library.html) 'platform_locator_web.dart';

class MoEngageService {
  MoEngageService._internal([MoEngagePlatform? platform]) {
    _platform = platform ?? getMoEngagePlatform();
    debugPrint('MoEngageService: Plataforma seleccionada por el compilador es ${_platform.runtimeType}');
  }

  static MoEngageService? _instance;
  late final MoEngagePlatform _platform;
  MoEngageGeofence? _moEngageGeofence;

  static MoEngageService get instance {
    _instance ??= MoEngageService._internal();
    return _instance!;
  }

  static MoEngageService init(
      {required String appId,required String pushToken, MoEngagePlatform? platform}) {
    _instance = MoEngageService._internal(platform);
    _instance!._platform.initialize(appId: appId, pushToken: pushToken);
    // Solo inicializar geofence en mobile
  /*  if (_instance!._platform is MoEngageMobilePlatform) {
      _instance!._moEngageGeofence = MoEngageGeofence(appId);
      _instance!._moEngageGeofence!.startGeofenceMonitoring();
    }*/
    return _instance!;
  }

  void setUniqueId(String uniqueId) => _platform.identifyUser(uniqueId);

  void trackCustomEvent(String eventName, {Map<String, Object>? attributes}) =>
      _platform.trackCustomEvent(eventName, attributes);

  void setUserAttribute(String name, dynamic value) =>
      _platform.setUserAttribute(name, value);

  void showInAppMessage() => _platform.showInAppMessage();

  void showNudge() => _platform.showNudge();

  void logout()  {
   /* if (_platform is MoEngageMobilePlatform && _moEngageGeofence != null) {
      _moEngageGeofence!.stopGeofenceMonitoring();
    }*/
    _platform.logout();
  }

  void setUserName(String userName) => _platform.setUserName(userName);

  void setUserEmail(String email) => _platform.setUserEmail(email);

  void setGender(String gender) {
    final MoEGender genderEnum = stringToGender(gender);
    _platform.setGender(genderEnum);
  }

  void setPhoneNumber(String phoneNumber) =>
      _platform.setPhoneNumber(phoneNumber);

  void setLastName(String lastName) => _platform.setLastName(lastName);

  void setFirstName(String firstName) => _platform.setFirstName(firstName);

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


  void startGeofenceMonitoring() {
    if (_platform is MoEngageMobilePlatform) {
      if (_moEngageGeofence == null) {
        debugPrint('MoEngageService: Geofence no está inicializado.');
        return;
      }
      _moEngageGeofence!.startGeofenceMonitoring();
    } else {
      debugPrint('MoEngageService: Geofence solo está disponible en plataformas móviles.');
    }
  }

  void setPushClickCallbackHandler(Function(PushCampaignData) handler) {
    if (_platform is MoEngageMobilePlatform) {
      final mobilePlatform = _platform as MoEngageMobilePlatform;
      mobilePlatform.setPushClickCallbackHandler(handler);
    }
  }
}
