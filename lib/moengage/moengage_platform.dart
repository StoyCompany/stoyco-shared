abstract class MoEngagePlatform {
  /// Inicializa el SDK de MoEngage con el App ID específico.
  Future<void> initialize({required String appId});

  /// Identifica al usuario con un ID único.
  Future<void> identifyUser(String uniqueId);

  /// Rastrea un evento personalizado con atributos opcionales.
  Future<void> trackCustomEvent(
      String eventName, Map<String, Object>? eventAttributes,);

  /// Establece un atributo para el usuario actual.
  Future<void> setUserAttribute(String attributeName, dynamic attributeValue);

  /// Cierra la sesión del usuario actual en MoEngage.
  Future<void> logout();
}