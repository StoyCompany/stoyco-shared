// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stoy_shop_product_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoyShopProductDataModel _$StoyShopProductDataModelFromJson(
        Map<String, dynamic> json) =>
    StoyShopProductDataModel(
      collectionId: (json['collectionId'] as num?)?.toInt(),
      symbol: json['symbol'] as String?,
      maxSupply: (json['maxSupply'] as num?)?.toInt(),
      minted: (json['minted'] as num?)?.toInt(),
      contractAddress: json['contractAddress'] as String?,
      txHash: json['txHash'] as String?,
      metadataUri: json['metadataUri'] as String?,
      imageUri: json['imageUri'] as String?,
      avatarBackgroundImageUri: json['avatarBackgroundImageUri'] as String?,
      burned: json['burned'] as bool?,
      artistOrBrandId: json['artistOrBrandId'] as String?,
      artistOrBrandName: json['artistOrBrandName'] as String?,
      communityId: json['communityId'] as String?,
      experienceOrProductName: json['experienceOrProductName'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map(
              (e) => StoyShopCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isExclusive: json['isExclusive'] as bool?,
    );

Map<String, dynamic> _$StoyShopProductDataModelToJson(
        StoyShopProductDataModel instance) =>
    <String, dynamic>{
      'collectionId': instance.collectionId,
      'symbol': instance.symbol,
      'maxSupply': instance.maxSupply,
      'minted': instance.minted,
      'contractAddress': instance.contractAddress,
      'txHash': instance.txHash,
      'metadataUri': instance.metadataUri,
      'imageUri': instance.imageUri,
      'avatarBackgroundImageUri': instance.avatarBackgroundImageUri,
      'burned': instance.burned,
      'artistOrBrandId': instance.artistOrBrandId,
      'artistOrBrandName': instance.artistOrBrandName,
      'communityId': instance.communityId,
      'experienceOrProductName': instance.experienceOrProductName,
      'categories': instance.categories,
      'isExclusive': instance.isExclusive,
    };
