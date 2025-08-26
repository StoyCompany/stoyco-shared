// lib/moengage/moengage_web_platform.dart
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter_web/moengage_flutter_web.dart';
import 'package:stoyco_shared/moengage/moengage_platform.dart'; // Asegúrate de que esta ruta sea correcta

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
    print("MoEngage Web: Evento '$eventName' rastreado con atributos: $eventAttributes");
  }

  @override
  Future<void> identifyUser(String uniqueId) async {
    _moengagePlugin.setUniqueId(uniqueId,_appId!);
    print("MoEngage Web: Usuario identificado con ID: $uniqueId");
  }

  @override
  Future<void> setUserAttribute(String attributeName, dynamic attributeValue) async {
    if (attributeValue is DateTime) {
      // El SDK web de MoEngage espera un objeto Date de JavaScript o una cadena ISO 8601.
      // `moengage_flutter_web` debería manejar la conversión de `DateTime` a una cadena ISO.
      // Para ser explícitos y seguros:
      _moengagePlugin.setUserAttribute(attributeName, attributeValue.toIso8601String(),_appId!);
    } else {
      _moengagePlugin.setUserAttribute(attributeName, attributeValue,_appId!);
    }
    print("MoEngage Web: Atributo de usuario '$attributeName' establecido en '$attributeValue'");
  }

  @override
  Future<void> logout() async {
    _moengagePlugin.logout(_appId!);
    print("MoEngage Web: Usuario deslogueado.");
  }
}
