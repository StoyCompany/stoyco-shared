import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';

class MoEngageMobilePlatform implements MoEngagePlatform {
  late final MoEngageFlutter _moengagePlugin;
  final MoEInitConfig _initConfig = MoEInitConfig(analyticsConfig: AnalyticsConfig(shouldTrackUserAttributeBooleanAsNumber: true));
  @override
  Future<void> initialize({required String appId}) async {
    if (appId.isEmpty) {
      debugPrint(
          'MoEngage Mobile: App ID es crucial para la inicialización y no fue proporcionado.',);
    }

    _moengagePlugin = MoEngageFlutter(appId, moEInitConfig: _initConfig);
    _setupInAppCallbacks();
    debugPrint("MoEngage Mobile: SDK inicializado con App ID: $appId");
  }

  @override
  Future<void> identifyUser(String uniqueId) async {
    _moengagePlugin.identifyUser(uniqueId);
    debugPrint("MoEngage Mobile: Usuario identificado con ID: $uniqueId");
  }

  @override
  Future<void> trackCustomEvent(
      String eventName, Map<String, Object>? eventAttributes) async {
    final MoEProperties properties = MoEProperties();
    if (eventAttributes != null) {
      eventAttributes.forEach((key, value) {
        properties.addAttribute(key, value);
      });
    }
    _moengagePlugin.trackEvent(eventName, properties);
    debugPrint("MoEngage Mobile: Evento '$eventName' rastreado.");
  }
  @override
  Future<void> setUserName(String userName) async {
    _moengagePlugin.setUserName(userName);
    debugPrint("MoEngage Mobile: Nombre de usuario establecido a '$userName'.");
  }
  @override
  Future<void> setUserEmail(String email) async {
    _moengagePlugin.setEmail(email);
    debugPrint("MoEngage Mobile: Email de usuario establecido a '$email'.");
  }

  @override
  Future<void> setPhoneNumber(String phoneNumber)async {
   _moengagePlugin.setPhoneNumber(phoneNumber);
  }

  @override
  Future<void> setGender(MoEGender gender)async {
   _moengagePlugin.setGender(gender);
  }

  @override
  Future<void> setLastName(String lastName) async{
   _moengagePlugin.setLastName(lastName);
  }

  @override
  Future<void> setUserAttribute(
      String attributeName, dynamic attributeValue) async {
    _moengagePlugin.setUserAttribute(attributeName, attributeValue);
    debugPrint("MoEngage Mobile: Atributo de usuario '$attributeName' establecido.");
  }

  @override
  Future<void> logout() async {
    _moengagePlugin.logout();
    debugPrint("MoEngage Mobile: Usuario deslogueado.");
  }

  @override
  Future<void> showInAppMessage() async {
    _moengagePlugin.showInApp();
    debugPrint("MoEngage Mobile: Intentando mostrar un In-App Message.");
  }

  @override
  Future<void> showNudge() async {
    _moengagePlugin.showNudge();
    debugPrint("MoEngage Mobile: Intentando mostrar un Nudge.");
  }



  void _setupInAppCallbacks() {
    _moengagePlugin.setInAppClickHandler(_onInAppClick);
    _moengagePlugin.setInAppShownCallbackHandler(_onInAppShown);
    _moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismissed);
    _moengagePlugin.setSelfHandledInAppHandler(_onInAppSelfHandled);
    debugPrint("MoEngage Mobile: Callbacks de In-App configurados.");
  }


  void _onInAppClick(ClickData message) {
    debugPrint("MoEngage Mobile: InApp Clicked. Payload: ${message.toString()}");
    final action = message.action;
    if (action is NavigationAction) {
      if (action.navigationType == NavigationType.screenName) {
        debugPrint("Acción de navegación a la pantalla: ${action.navigationUrl}");
        // Ejemplo: navigatorKey.currentState?.pushNamed(action.navigationUrl);
      } else if (action.navigationType == NavigationType.deeplink) {
        debugPrint("Acción de deep link: ${action.navigationUrl}");
        // Lógica para manejar el deep link
      }
    }
  }


  void _onInAppShown(InAppData message) {
    debugPrint("MoEngage Mobile: InApp Shown. Campaign: ${message.campaignData.campaignName}");
  }


  void _onInAppDismissed(InAppData message) {
    debugPrint("MoEngage Mobile: InApp Dismissed. Campaign: ${message.campaignData.campaignName}");
  }


  void _onInAppSelfHandled(SelfHandledCampaignData? message) {
    if (message != null) {
      debugPrint("MoEngage Mobile: Self-Handled InApp disponible. Payload: ${message.campaign.payload}");
    }
  }

  @override
  Future<void> setFirstName(String firstName) async {
    _moengagePlugin.setFirstName(firstName);
    debugPrint("MoEngage Mobile: Nombre de usuario establecido a '$firstName'.");
  }
}