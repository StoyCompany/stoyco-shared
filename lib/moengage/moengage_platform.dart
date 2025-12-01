import 'package:moengage_flutter/moengage_flutter.dart';

abstract class MoEngagePlatform {
  /// Initializes the MoEngage SDK with the specific App ID.
  ///
  /// This method must be called before any other MoEngage SDK methods
  /// to ensure proper functionality and tracking.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.initialize(appId: "YOUR_MOENGAGE_APP_ID");
  /// ```
  void initialize({required String appId,required String pushToken});

  /// Identifies the user with a unique ID.
  ///
  /// This should be called when a user logs in or is uniquely identified
  /// within your application. This associates all subsequent events
  /// and user attributes with this specific user.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.identifyUser("user_12345");
  /// ```
  void identifyUser(String uniqueId);

  /// Tracks a custom event with optional attributes.
  ///
  /// Use this to track specific actions or behaviors of users within your app.
  /// Attributes provide additional context about the event, allowing for
  /// richer analytics and segmentation.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.trackCustomEvent(
  ///   "Product Viewed",
  ///   {
  ///     "Product Name": "Awesome Gadget",
  ///     "Product ID": 12345,
  ///     "Category": "Electronics",
  ///     "Price": 99.99,
  ///   },
  /// );
  ///
  /// // Tracking an event without attributes
  ///  MoEngagePlatform.instance.trackCustomEvent("App Launched", null);
  /// ```
  void trackCustomEvent(
    String eventName,
    Map<String, Object>? eventAttributes,
  );

  /// Sets an attribute for the current user.
  ///
  /// This allows you to store custom data points about your users,
  /// which can be used for segmentation, personalization, and filtering.
  /// The `attributeValue` can be of various types like `String`, `int`, `double`, `bool`, `DateTime`.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.setUserAttribute("User Tier", "Premium");
  ///  MoEngagePlatform.instance.setUserAttribute("Last Login Date", DateTime.now().toIso8601String());
  ///  MoEngagePlatform.instance.setUserAttribute("Is Subscriber", true);
  /// ```
  void setUserAttribute(String attributeName, dynamic attributeValue);

  /// Logs out the current user from MoEngage.
  ///
  /// This method should be called when a user logs out of your application.
  /// It clears the current user's identity and starts a new session for an
  /// anonymous user, or for a new user if `identifyUser` is called subsequently.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.logout();
  /// ```
  void logout();

  /// Shows an in-app message if there is any campaign available.
  ///
  /// This method triggers the display of a MoEngage in-app message
  /// configured for the current user and context. Only works on Android and iOS.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.showInAppMessage();
  /// ```
  void showInAppMessage();

  /// Shows a nudge if there is any campaign available.
  ///
  /// This method triggers the display of a MoEngage nudge campaign
  /// configured for the current user and context. Only works on Android and iOS.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.showNudge();
  /// ```
  void showNudge();

  /// Sets the user's full name.
  ///
  /// Use this to store the user's full name as a standard user attribute in MoEngage.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.setUserName("John Doe");
  /// ```
  void setUserName(String userName);

  /// Sets the user's email address.
  ///
  /// Use this to store the user's email as a standard user attribute in MoEngage.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.setUserEmail("john.doe@example.com");
  /// ```
  void setUserEmail(String email);

  /// Sets the user's gender.
  ///
  /// Use this to store the user's gender as a standard user attribute in MoEngage.
  /// The `MoEGender` enum is part of `package:moengage_flutter/moengage_flutter.dart`.
  ///
  /// Example:
  /// ```dart
  /// import 'package:moengage_flutter/moengage_flutter.dart';
  /// // ...
  ///  MoEngagePlatform.instance.setGender(MoEGender.male);
  /// // Or for other options: MoEGender.female, MoEGender.notSpecified
  /// ```
  void setGender(MoEGender gender);

  /// Sets the user's phone number.
  ///
  /// Use this to store the user's phone number as a standard user attribute in MoEngage.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.setPhoneNumber("+1-555-123-4567");
  ///
  ///
  /// ```
  void setPhoneNumber(String phoneNumber);

  /// Sets the user's last name.
  ///
  /// Use this to store the user's last name as a standard user attribute in MoEngage.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.setLastName("Doe");
  /// ```
  void setLastName(String lastName);

  /// Sets the user's first name.
  ///
  /// Use this to store the user's first name as a standard user attribute in MoEngage.
  ///
  /// Example:
  /// ```dart
  ///  MoEngagePlatform.instance.setFirstName("John");
  /// ```
  void setFirstName(String firstName);
}
