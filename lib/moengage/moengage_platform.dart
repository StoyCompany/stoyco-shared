import 'package:moengage_flutter/moengage_flutter.dart';

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

  ///show in app message if there is any campaign available.
  ///Only works on Android and iOS.
  Future<void> showInAppMessage();

  ///show nudge if there is any campaign available.
  ///Only works on Android and iOS.
  Future<void> showNudge();

  /// Sets the user's name.
  Future<void> setUserName(String userName);
  /// Sets the user's email.
  Future<void> setUserEmail(String email);
  /// Sets the user's gender.
  Future<void> setGender(MoEGender gender);
  /// Sets the user's phone number.
  Future<void> setPhoneNumber(String phoneNumber);
  /// Sets the user's last name.
  Future<void> setLastName(String lastName);
  /// Sets the user's first name.
  Future<void> setFirstName(String firstName);
}
