import 'package:stoyco_shared/revenuecat/models/customer_info_model.dart';

class PurchaseResultModel {

  PurchaseResultModel({
    required this.customerInfo,
    required this.userCancelled,
  });
  final CustomerInfoModel customerInfo;
  final bool userCancelled;
}

