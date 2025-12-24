import 'package:purchases_flutter/purchases_flutter.dart';

class OfferingModel {

  OfferingModel({
    required this.identifier,
    required this.serverDescription,
    required this.availablePackages,
    this.monthly,
    this.annual,
    this.lifetime,
  });

  factory OfferingModel.fromOffering(Offering offering) => OfferingModel(
      identifier: offering.identifier,
      serverDescription: offering.serverDescription,
      availablePackages: offering.availablePackages
          .map((p) => PackageModel.fromPackage(p))
          .toList(),
      monthly: offering.monthly != null
          ? PackageModel.fromPackage(offering.monthly!)
          : null,
      annual: offering.annual != null
          ? PackageModel.fromPackage(offering.annual!)
          : null,
      lifetime: offering.lifetime != null
          ? PackageModel.fromPackage(offering.lifetime!)
          : null,
    );
  final String identifier;
  final String serverDescription;
  final List<PackageModel> availablePackages;
  final PackageModel? monthly;
  final PackageModel? annual;
  final PackageModel? lifetime;
}

class PackageModel {

  factory PackageModel.fromPackage(Package package) => PackageModel(
        identifier: package.identifier,
        packageType: package.packageType,
        storeProduct: package.storeProduct,
      );

  PackageModel({
    required this.identifier,
    required this.packageType,
    required this.storeProduct,
  });
  final String identifier;
  final PackageType packageType;
  final StoreProduct storeProduct;

  String get priceString => storeProduct.priceString;
  String get productIdentifier => storeProduct.identifier;
  String get title => storeProduct.title;
  String get description => storeProduct.description;
}

