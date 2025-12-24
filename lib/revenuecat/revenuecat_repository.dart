import 'package:either_dart/either.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stoyco_shared/errors/errors.dart';
import 'package:stoyco_shared/revenuecat/models/customer_info_model.dart';
import 'package:stoyco_shared/revenuecat/models/offering_model.dart';
import 'package:stoyco_shared/revenuecat/models/purchase_result_model.dart';
import 'package:stoyco_shared/revenuecat/revenuecat_data_source.dart';
import 'package:stoyco_shared/utils/logger.dart';

class RevenueCatRepository {

  RevenueCatRepository(this._dataSource);
  final RevenueCatDataSource _dataSource;

  Future<Either<Failure, void>> configure({
    required String apiKey,
    String? appUserId,
  }) async {
    try {
      await _dataSource.configure(
        apiKey: apiKey,
        appUserId: appUserId,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Error configuring RevenueCat',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }

  Future<Either<Failure, CustomerInfoModel>> getCustomerInfo() async {
    try {
      final customerInfo = await _dataSource.getCustomerInfo();
      return Right(customerInfo);
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Error getting customer info',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }

  Future<Either<Failure, OfferingModel?>> getCurrentOffering() async {
    try {
      final offering = await _dataSource.getCurrentOffering();
      return Right(offering);
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Error getting current offering',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }

  Future<Either<Failure, PurchaseResultModel>> purchasePackage(
      Package package) async {
    try {
      final result = await _dataSource.purchasePackage(package);
      return Right(result);
    } on PlatformException catch (e, stackTrace) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      StoyCoLogger.error(
        'Error purchasing package: $errorCode',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        PlatformFailure.decode(e),
      );
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Unexpected error purchasing package',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }

  Future<Either<Failure, void>> logIn(String appUserId) async {
    try {
      await _dataSource.logIn(appUserId);
      return const Right(null);
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Error logging in user',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }

  Future<Either<Failure, void>> logOut() async {
    try {
      await _dataSource.logOut();
      return const Right(null);
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Error logging out user',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }

  Future<Either<Failure, CustomerInfoModel>> restorePurchases() async {
    try {
      final customerInfo = await _dataSource.restorePurchases();
      return Right(customerInfo);
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Error restoring purchases',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }

  Future<Either<Failure, void>> setAttributes(
      Map<String, String> attributes) async {
    try {
      await _dataSource.setAttributes(attributes);
      return const Right(null);
    } catch (e, stackTrace) {
      StoyCoLogger.error(
        'Error setting attributes',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ExceptionFailure.decode(e as Exception?),
      );
    }
  }
}

