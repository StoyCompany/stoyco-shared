import 'package:json_annotation/json_annotation.dart';

part 'stoy_shop_product_data_model.g.dart';

/// Nested data for NFT/collection products in the StoyShop.
///
/// Contains blockchain-related information and metadata for NFT products.
@JsonSerializable()
class StoyShopProductDataModel {
  const StoyShopProductDataModel({
    this.collectionId,
    this.symbol,
    this.maxSupply,
    this.minted,
    this.contractAddress,
    this.txHash,
    this.metadataUri,
    this.imageUri,
    this.avatarBackgroundImageUri,
    this.burned,
    this.artistOrBrandId,
    this.artistOrBrandName,
    this.communityId,
    this.experienceOrProductName,
    this.categories,
    this.isExclusive,
  });

  factory StoyShopProductDataModel.fromJson(Map<String, dynamic> json) =>
      _$StoyShopProductDataModelFromJson(json);

  final int? collectionId;
  final String? symbol;
  final int? maxSupply;
  final int? minted;
  final String? contractAddress;
  final String? txHash;
  final String? metadataUri;
  final String? imageUri;
  final String? avatarBackgroundImageUri;
  final bool? burned;
  final String? artistOrBrandId;
  final String? artistOrBrandName;
  final String? communityId;
  final String? experienceOrProductName;
  final List<String>? categories;
  final bool? isExclusive;

  Map<String, dynamic> toJson() => _$StoyShopProductDataModelToJson(this);

  StoyShopProductDataModel copyWith({
    int? collectionId,
    String? symbol,
    int? maxSupply,
    int? minted,
    String? contractAddress,
    String? txHash,
    String? metadataUri,
    String? imageUri,
    String? avatarBackgroundImageUri,
    bool? burned,
    String? artistOrBrandId,
    String? artistOrBrandName,
    String? communityId,
    String? experienceOrProductName,
    List<String>? categories,
    bool? isExclusive,
  }) =>
      StoyShopProductDataModel(
        collectionId: collectionId ?? this.collectionId,
        symbol: symbol ?? this.symbol,
        maxSupply: maxSupply ?? this.maxSupply,
        minted: minted ?? this.minted,
        contractAddress: contractAddress ?? this.contractAddress,
        txHash: txHash ?? this.txHash,
        metadataUri: metadataUri ?? this.metadataUri,
        imageUri: imageUri ?? this.imageUri,
        avatarBackgroundImageUri:
            avatarBackgroundImageUri ?? this.avatarBackgroundImageUri,
        burned: burned ?? this.burned,
        artistOrBrandId: artistOrBrandId ?? this.artistOrBrandId,
        artistOrBrandName: artistOrBrandName ?? this.artistOrBrandName,
        communityId: communityId ?? this.communityId,
        experienceOrProductName:
            experienceOrProductName ?? this.experienceOrProductName,
        categories: categories ?? this.categories,
        isExclusive: isExclusive ?? this.isExclusive,
      );
}
