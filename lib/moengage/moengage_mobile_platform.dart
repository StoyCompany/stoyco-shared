import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';

class MoEngageMobilePlatform implements MoEngagePlatform {
  late final MoEngageFlutter _moengagePlugin;
  final MoEInitConfig _initConfig = MoEInitConfig(analyticsConfig: AnalyticsConfig(shouldTrackUserAttributeBooleanAsNumber: true));
  @override
  Future<void> initialize({required String appId}) async {
    // Es buena práctica verificar el appId antes de usarlo.
    if (appId.isEmpty) {
      debugPrint(
          'MoEngage Mobile: App ID es crucial para la inicialización y no fue proporcionado.',);
    }

    _moengagePlugin = MoEngageFlutter(appId,moEInitConfig: _initConfig);

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
  Future<void> setUserAttribute(
      String attributeName, dynamic attributeValue) async {
    // El SDK móvil maneja diferentes tipos de datos, no es necesario convertir a String.
    _moengagePlugin.setUserAttribute(attributeName, attributeValue);
    debugPrint("MoEngage Mobile: Atributo de usuario '$attributeName' establecido.");
  }

  @override
  Future<void> logout() async {
    _moengagePlugin.logout();
    debugPrint("MoEngage Mobile: Usuario deslogueado.");
  }
}