import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/stoy_shop/models/stoy_shop_product_data_model.dart';

part 'stoy_shop_product_model.g.dart';

/// Represents a product item in the StoyShop.
///
/// Products can be NFTs, cultural assets, or other digital goods
/// available for purchase or redemption in the store.
@JsonSerializable()
class StoyShopProductModel {
  const StoyShopProductModel({
    this.id,
    this.name,
    this.imageUrl,
    this.stock,
    this.points,
    this.typeParametrization,
    this.createdAt,
    this.isSubscriberOnly,
    this.accessContent,
    this.productId,
    this.data,
  });

  factory StoyShopProductModel.fromJson(Map<String, dynamic> json) =>
      _$StoyShopProductModelFromJson(json);

  final String? id;
  final String? name;
  final String? imageUrl;
  final int? stock;
  final int? points;
  final String? typeParametrization;
  final DateTime? createdAt;
  final bool? isSubscriberOnly;
  final String? accessContent;
  final String? productId;
  final StoyShopProductDataModel? data;

  Map<String, dynamic> toJson() => _$StoyShopProductModelToJson(this);

  StoyShopProductModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? stock,
    int? points,
    String? typeParametrization,
    DateTime? createdAt,
    bool? isSubscriberOnly,
    String? accessContent,
    String? productId,
    StoyShopProductDataModel? data,
  }) =>
      StoyShopProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        stock: stock ?? this.stock,
        points: points ?? this.points,
        typeParametrization: typeParametrization ?? this.typeParametrization,
        createdAt: createdAt ?? this.createdAt,
        isSubscriberOnly: isSubscriberOnly ?? this.isSubscriberOnly,
        accessContent: accessContent ?? this.accessContent,
        productId: productId ?? this.productId,
        data: data ?? this.data,
      );

  bool get isNft => typeParametrization == 'NFT_VALUE';

  bool get isAvailable => (stock ?? 0) > 0;

  bool get isSoldOut => (stock ?? 0) == 0;
}
