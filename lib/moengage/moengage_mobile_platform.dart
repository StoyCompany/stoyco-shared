import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_geofence/moengage_geofence.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';
import 'package:stoyco_shared/stoyco_shared.dart';

class MoEngageMobilePlatform implements MoEngagePlatform {
  late final MoEngageFlutter _moengagePlugin;
  late final MoEngageGeofence _moEngageGeofence;
  final MoEInitConfig _initConfig = MoEInitConfig(
    pushConfig: PushConfig(shouldDeliverCallbackOnForegroundClick: true),
      analyticsConfig:
          AnalyticsConfig(shouldTrackUserAttributeBooleanAsNumber: true),);

  @override
  void initialize({required String appId,required String pushToken}) {
    if (appId.isEmpty) {
      StoyCoLogger.info('MoEngage Mobile: App ID es crucial para la inicialización y no fue proporcionado.');
    }

    _moengagePlugin = MoEngageFlutter(appId, moEInitConfig: _initConfig);
    _moEngageGeofence = MoEngageGeofence(appId);
    _moengagePlugin.initialise();
    _moengagePlugin.passFCMPushToken(pushToken);
    _moengagePlugin.registerForPushNotification();
    _setupInAppCallbacks();
  }

  @override
  void identifyUser(String uniqueId) {
    _moengagePlugin.identifyUser(uniqueId);
  }

  @override
  void trackCustomEvent(
      String eventName, Map<String, Object>? eventAttributes) {
    final MoEProperties properties = MoEProperties();
    if (eventAttributes != null) {
      eventAttributes.forEach((key, value) {
        properties.addAttribute(key, value);
      });
    }
    _moengagePlugin.trackEvent(eventName, properties);
  }

  @override
  void setUserName(String userName) => _moengagePlugin.setUserName(userName);

  @override
  void setUserEmail(String email) => _moengagePlugin.setEmail(email);

  @override
  void setPhoneNumber(String phoneNumber) =>
      _moengagePlugin.setPhoneNumber(phoneNumber);

  @override
  void setGender(MoEGender gender) => _moengagePlugin.setGender(gender);

  @override
  void setLastName(String lastName) => _moengagePlugin.setLastName(lastName);

  @override
  void setFirstName(String firstName) =>
      _moengagePlugin.setFirstName(firstName);

  @override
  void setUserAttribute(String attributeName, dynamic attributeValue) =>
      _moengagePlugin.setUserAttribute(attributeName, attributeValue);

  @override
  void logout() => _moengagePlugin.logout();

  @override
  void showInAppMessage() => _moengagePlugin.showInApp();

  @override
  void showNudge() => _moengagePlugin.showNudge();

  void _setupInAppCallbacks() {
    _moengagePlugin.setInAppClickHandler(_onInAppClick);
    _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
    _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismissed);
    _moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandled);
  }


  void startGeofenceMonitoring() {
    _moEngageGeofence.startGeofenceMonitoring();
  }

  void stopGeofenceMonitoring() {
    _moEngageGeofence.stopGeofenceMonitoring();
  }

  ///TODO METODOS DE INAPP A IMPLEMENTAR SEGUN NECESIDADES
  void _onInAppClick(ClickData message) {
    StoyCoLogger.info('MoEngage Mobile: InApp Clicked. Payload: ${message.toString()}');
    final action = message.action;
    if (action is NavigationAction) {
      if (action.navigationType == NavigationType.screenName) {
        StoyCoLogger.info(
            'Acción de navegación a la pantalla: ${action.navigationUrl}');
        // Ejemplo: navigatorKey.currentState?.pushNamed(action.navigationUrl);
      } else if (action.navigationType == NavigationType.deeplink) {
        StoyCoLogger.info('Acción de deep link: ${action.navigationUrl}');
        // Lógica para manejar el deep link
      }
    }
  }

  void _onInAppShown(InAppData message) {
    StoyCoLogger.info(
        'MoEngage Mobile: InApp Shown. Campaign: ${message.campaignData.campaignName}');
  }

  void _onInAppDismissed(InAppData message) {
    StoyCoLogger.info(
        'MoEngage Mobile: InApp Dismissed. Campaign: ${message.campaignData.campaignName}');
  }

  void _onInAppSelfHandled(SelfHandledCampaignData? message) {
    if (message != null) {
      StoyCoLogger.info(
          'MoEngage Mobile: Self-Handled InApp disponible. Payload: ${message.campaign.payload}');
    }
  }

  void setPushClickCallbackHandler(Function(PushCampaignData) handler) {
    _moengagePlugin.setPushClickCallbackHandler(handler);
  }
}
