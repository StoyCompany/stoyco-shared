import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';

class MoEngageMobilePlatform implements MoEngagePlatform {
  late final MoEngageFlutter _moengagePlugin;
  final MoEInitConfig _initConfig = MoEInitConfig(
    pushConfig: PushConfig(shouldDeliverCallbackOnForegroundClick: true),
      analyticsConfig:
          AnalyticsConfig(shouldTrackUserAttributeBooleanAsNumber: true),);

  @override
  void initialize({required String appId,required String pushToken}) {
    if (appId.isEmpty) {
      debugPrint(
        'MoEngage Mobile: App ID es crucial para la inicialización y no fue proporcionado.',
      );
    }

    _moengagePlugin = MoEngageFlutter(appId, moEInitConfig: _initConfig);
    _moengagePlugin.initialise();
    _moengagePlugin.passFCMPushToken(pushToken);
   // _moengagePlugin.passPushKitPushToken(pushToken);
    _moengagePlugin.registerForPushNotification();
   // _moengagePlugin.registerForProvisionalPush();
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

  ///TODO METODOS DE INAPP A IMPLEMENTAR SEGUN NECESIDADES
  void _onInAppClick(ClickData message) {
    debugPrint(
        "MoEngage Mobile: InApp Clicked. Payload: ${message.toString()}");
    final action = message.action;
    if (action is NavigationAction) {
      if (action.navigationType == NavigationType.screenName) {
        debugPrint(
            "Acción de navegación a la pantalla: ${action.navigationUrl}");
        // Ejemplo: navigatorKey.currentState?.pushNamed(action.navigationUrl);
      } else if (action.navigationType == NavigationType.deeplink) {
        debugPrint("Acción de deep link: ${action.navigationUrl}");
        // Lógica para manejar el deep link
      }
    }
  }

  void _onInAppShown(InAppData message) {
    debugPrint(
        "MoEngage Mobile: InApp Shown. Campaign: ${message.campaignData.campaignName}");
  }

  void _onInAppDismissed(InAppData message) {
    debugPrint(
        "MoEngage Mobile: InApp Dismissed. Campaign: ${message.campaignData.campaignName}");
  }

  void _onInAppSelfHandled(SelfHandledCampaignData? message) {
    if (message != null) {
      debugPrint(
          "MoEngage Mobile: Self-Handled InApp disponible. Payload: ${message.campaign.payload}");
    }
  }

  void setPushClickCallbackHandler(Function(PushCampaignData) handler) {
    _moengagePlugin.setPushClickCallbackHandler(handler);
  }
}
