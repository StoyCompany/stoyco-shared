abstract class MoEngagePlatform {
  /// Initializes the MoEngage SDK with the specific App ID.
  Future<void> initialize({required String appId});

  /// Identifies the user with a unique ID.
  Future<void> identifyUser(String uniqueId);

  /// Tracks a custom event with optional attributes.
  Future<void> trackCustomEvent(String eventName,
      Map<String, Object>? eventAttributes,);

  /// Sets an attribute for the current user.
  Future<void> setUserAttribute(String attributeName, dynamic attributeValue);

  /// Logs out the current user from MoEngage.
  Future<void> logout();
}