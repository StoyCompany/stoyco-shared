import 'package:stoyco_shared/notification/types/notification_type.dart';

/// Utility class for handling notification-related operations.
/// This class provides static methods and constants for managing notifications,
/// particularly focusing on web platform compatibility.
abstract class NotificationsUtils {
  /// Set of notification types that are allowed to be displayed on web platform.
  static const Set<NotificationType> notificationsAllowedForWeb = {
    NotificationType.unknown,
    NotificationType.partner,
    NotificationType.community,
    NotificationType.product,
    NotificationType.communityDetail,
    NotificationType.partnerConnectSesh,
    NotificationType.temporaryVotes,
    NotificationType.deadlineToVote,
    NotificationType.purchaseOrder,
    NotificationType.onboardingCompleted,
    NotificationType.messages,
    NotificationType.home,
    NotificationType.notifications,
    NotificationType.editProfile,
    NotificationType.shoppingHistoryProducts,
    NotificationType.shoppingHistoryExperiences,
    NotificationType.communitiesPages,
    NotificationType.wallet,
    NotificationType.walletShop,
    NotificationType.walletShopPurchaseInfo,
  };

  /// Checks if a given notification type is allowed for web platform.
  ///
  /// @param type The notification type to check
  /// @return true if the notification type is allowed for web, false otherwise
  static bool isNotificationAllowedForWeb(NotificationType type) =>
      notificationsAllowedForWeb.contains(type);

  /// Checks if a notification is allowed for web platform by its ID.
  ///
  /// @param id The integer ID of the notification type
  /// @return true if the notification type corresponding to the ID is allowed for web, false otherwise
  static bool isNotificationAllowedForWebById(int id) =>
      notificationsAllowedForWeb.contains(NotificationType.fromInt(id));
}
