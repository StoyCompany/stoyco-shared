import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart';

class MoEngageMobilePlatform implements MoEngagePlatform {
  // Usamos 'late' porque se inicializará de forma asíncrona en 'initialize'.
  late final MoEngageFlutter _moengagePlugin;

  @override
  Future<void> initialize({required String appId}) async {
    // Es buena práctica verificar el appId antes de usarlo.
    if (appId.isEmpty) {
      debugPrint(
          'MoEngage Mobile: App ID es crucial para la inicialización y no fue proporcionado.',);
    }

    _moengagePlugin = MoEngageFlutter(appId);

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
        // MoEngage recomienda validar los tipos de datos, pero addAttribute es flexible.
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