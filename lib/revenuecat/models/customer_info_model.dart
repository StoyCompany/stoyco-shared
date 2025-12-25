import 'package:purchases_flutter/purchases_flutter.dart';

class CustomerInfoModel {

  factory CustomerInfoModel.fromCustomerInfo(CustomerInfo info) =>
      CustomerInfoModel(
        originalAppUserId: info.originalAppUserId,
        allPurchaseDates: info.allPurchaseDates,
        allExpirationDates: info.allExpirationDates,
        activeSubscriptions: info.activeSubscriptions,
        entitlements: info.entitlements.all,
        latestExpirationDate: info.latestExpirationDate,
      );

  CustomerInfoModel({
    required this.originalAppUserId,
    required this.allPurchaseDates,
    required this.allExpirationDates,
    required this.activeSubscriptions,
    required this.entitlements,
    this.latestExpirationDate,
  });
  final String originalAppUserId;
  final Map<String, dynamic> allPurchaseDates;
  final Map<String, dynamic> allExpirationDates;
  final List<String> activeSubscriptions;
  final Map<String, EntitlementInfo> entitlements;
  final String? latestExpirationDate;

  bool hasActiveEntitlement(String entitlementId) =>
      entitlements[entitlementId]?.isActive ?? false;

  bool get hasActiveSubscription => activeSubscriptions.isNotEmpty;
}

