import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stoyco_shared/revenuecat/models/customer_info_model.dart';
import 'package:stoyco_shared/revenuecat/models/offering_model.dart';
import 'package:stoyco_shared/revenuecat/models/purchase_result_model.dart';

abstract class RevenueCatDataSource {
  factory RevenueCatDataSource() {
    if (Platform.isIOS) {
      return _RevenueCatDataSourceIOS();
    } else if (Platform.isAndroid) {
      return _RevenueCatDataSourceAndroid();
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Future<void> configure({
    required String apiKey,
    String? appUserId,
  });

  Future<CustomerInfoModel> getCustomerInfo();

  Future<OfferingModel?> getCurrentOffering();

  Future<PurchaseResultModel> purchasePackage(Package package);

  Future<void> logIn(String appUserId);

  Future<void> logOut();

  Future<CustomerInfoModel> restorePurchases();

  Future<void> setAttributes(Map<String, String> attributes);
}

class _RevenueCatDataSourceIOS implements RevenueCatDataSource {
  @override
  Future<void> configure({
    required String apiKey,
    String? appUserId,
  }) async {
    final configuration = PurchasesConfiguration(apiKey);
    if (appUserId != null) {
      configuration.appUserID = appUserId;
    }
    await Purchases.configure(configuration);
  }

  @override
  Future<CustomerInfoModel> getCustomerInfo() async {
    final customerInfo = await Purchases.getCustomerInfo();
    return CustomerInfoModel.fromCustomerInfo(customerInfo);
  }

  @override
  Future<OfferingModel?> getCurrentOffering() async {
    final offerings = await Purchases.getOfferings();
    if (offerings.current == null) return null;
    return OfferingModel.fromOffering(offerings.current!);
  }

  @override
  Future<PurchaseResultModel> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      return PurchaseResultModel(
        customerInfo:
            CustomerInfoModel.fromCustomerInfo(purchaseResult.customerInfo),
        userCancelled: false,
      );
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        final customerInfo = await Purchases.getCustomerInfo();
        return PurchaseResultModel(
          customerInfo: CustomerInfoModel.fromCustomerInfo(customerInfo),
          userCancelled: true,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> logIn(String appUserId) async {
    await Purchases.logIn(appUserId);
  }

  @override
  Future<void> logOut() async {
    await Purchases.logOut();
  }

  @override
  Future<CustomerInfoModel> restorePurchases() async {
    final customerInfo = await Purchases.restorePurchases();
    return CustomerInfoModel.fromCustomerInfo(customerInfo);
  }

  @override
  Future<void> setAttributes(Map<String, String> attributes) async {
    for (final entry in attributes.entries) {
      await Purchases.setAttributes({entry.key: entry.value});
    }
  }
}

class _RevenueCatDataSourceAndroid implements RevenueCatDataSource {
  @override
  Future<void> configure({
    required String apiKey,
    String? appUserId,
  }) async {
    final configuration = PurchasesConfiguration(apiKey);
    if (appUserId != null) {
      configuration.appUserID = appUserId;
    }
    await Purchases.configure(configuration);
  }

  @override
  Future<CustomerInfoModel> getCustomerInfo() async {
    final customerInfo = await Purchases.getCustomerInfo();
    return CustomerInfoModel.fromCustomerInfo(customerInfo);
  }

  @override
  Future<OfferingModel?> getCurrentOffering() async {
    final offerings = await Purchases.getOfferings();
    if (offerings.current == null) return null;
    return OfferingModel.fromOffering(offerings.current!);
  }

  @override
  Future<PurchaseResultModel> purchasePackage(Package package) async {
    try {
      final purchaseResult = await Purchases.purchasePackage(package);
      return PurchaseResultModel(
        customerInfo:
            CustomerInfoModel.fromCustomerInfo(purchaseResult.customerInfo),
        userCancelled: false,
      );
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        final customerInfo = await Purchases.getCustomerInfo();
        return PurchaseResultModel(
          customerInfo: CustomerInfoModel.fromCustomerInfo(customerInfo),
          userCancelled: true,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> logIn(String appUserId) async {
    await Purchases.logIn(appUserId);
  }

  @override
  Future<void> logOut() async {
    await Purchases.logOut();
  }

  @override
  Future<CustomerInfoModel> restorePurchases() async {
    final customerInfo = await Purchases.restorePurchases();
    return CustomerInfoModel.fromCustomerInfo(customerInfo);
  }

  @override
  Future<void> setAttributes(Map<String, String> attributes) async {
    for (final entry in attributes.entries) {
      await Purchases.setAttributes({entry.key: entry.value});
    }
  }
}

