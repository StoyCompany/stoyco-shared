// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stoy_shop_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoyShopProductModel _$StoyShopProductModelFromJson(
        Map<String, dynamic> json) =>
    StoyShopProductModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      stock: (json['stock'] as num?)?.toInt(),
      points: (json['points'] as num?)?.toInt(),
      typeParametrization: json['typeParametrization'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      isSubscriberOnly: json['isSubscriberOnly'] as bool?,
      accessContent: json['accessContent'] as String?,
      productId: json['productId'] as String?,
      data: json['data'] == null
          ? null
          : StoyShopProductDataModel.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StoyShopProductModelToJson(
        StoyShopProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'stock': instance.stock,
      'points': instance.points,
      'typeParametrization': instance.typeParametrization,
      'createdAt': instance.createdAt?.toIso8601String(),
      'isSubscriberOnly': instance.isSubscriberOnly,
      'accessContent': instance.accessContent,
      'productId': instance.productId,
      'data': instance.data,
    };
