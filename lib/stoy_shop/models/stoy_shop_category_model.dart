import 'package:json_annotation/json_annotation.dart';

part 'stoy_shop_category_model.g.dart';

/// Represents a category with benefits and brands for a StoyShop product.
@JsonSerializable()
class StoyShopCategoryModel {
  const StoyShopCategoryModel({
    this.id,
    this.name,
    this.benefits,
    this.brands,
  });

  factory StoyShopCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoyShopCategoryModelFromJson(json);

  final String? id;
  final String? name;
  final List<CategoryBenefitModel>? benefits;
  final List<CategoryBrandModel>? brands;

  Map<String, dynamic> toJson() => _$StoyShopCategoryModelToJson(this);
}

/// Represents a benefit type for a category.
@JsonSerializable()
class CategoryBenefitModel {
  const CategoryBenefitModel({
    this.type,
    this.selected,
  });

  factory CategoryBenefitModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryBenefitModelFromJson(json);

  final String? type;
  final bool? selected;

  Map<String, dynamic> toJson() => _$CategoryBenefitModelToJson(this);
}

/// Represents a brand associated with a category.
@JsonSerializable()
class CategoryBrandModel {
  const CategoryBrandModel({
    this.id,
    this.name,
  });

  factory CategoryBrandModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryBrandModelFromJson(json);

  final String? id;
  final String? name;

  Map<String, dynamic> toJson() => _$CategoryBrandModelToJson(this);
}
