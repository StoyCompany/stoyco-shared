import 'package:either_dart/either.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/revenuecat/models/customer_info_model.dart';
import 'package:stoyco_shared/revenuecat/models/offering_model.dart';
import 'package:stoyco_shared/revenuecat/models/purchase_result_model.dart';
import 'package:stoyco_shared/revenuecat/revenuecat_data_source.dart';
import 'package:stoyco_shared/revenuecat/revenuecat_repository.dart';

class RevenueCatService {
  static RevenueCatService? _instance;
  final RevenueCatRepository _repository;

  RevenueCatService._internal(this._repository);

  factory RevenueCatService() {
    if (_instance == null) {
      final dataSource = RevenueCatDataSource();
      final repository = RevenueCatRepository(dataSource);
      _instance = RevenueCatService._internal(repository);
    }
    return _instance!;
  }

  static void resetInstance() {
    _instance = null;
  }

  Future<Either<Failure, void>> configure({
    required String apiKey,
    String? appUserId,
  }) =>
      _repository.configure(
        apiKey: apiKey,
        appUserId: appUserId,
      );

  Future<Either<Failure, CustomerInfoModel>> getCustomerInfo() =>
      _repository.getCustomerInfo();

  Future<Either<Failure, OfferingModel?>> getCurrentOffering() =>
      _repository.getCurrentOffering();

  Future<Either<Failure, PurchaseResultModel>> purchasePackage(
          Package package,) =>
      _repository.purchasePackage(package);

  Future<Either<Failure, void>> logIn(String appUserId) =>
      _repository.logIn(appUserId);

  Future<Either<Failure, void>> logOut() => _repository.logOut();

  Future<Either<Failure, CustomerInfoModel>> restorePurchases() =>
      _repository.restorePurchases();

  Future<Either<Failure, void>> setAttributes(
          Map<String, String> attributes) =>
      _repository.setAttributes(attributes);

  Future<Either<Failure, bool>> hasActiveEntitlement(
      String entitlementId) async {
    final result = await getCustomerInfo();
    return result.fold(
      (failure) => Left(failure),
      (customerInfo) => Right(customerInfo.hasActiveEntitlement(entitlementId)),
    );
  }

  Future<Either<Failure, bool>> hasActiveSubscription() async {
    final result = await getCustomerInfo();
    return result.fold(
      (failure) => Left(failure),
      (customerInfo) => Right(customerInfo.hasActiveSubscription),
    );
  }
}

