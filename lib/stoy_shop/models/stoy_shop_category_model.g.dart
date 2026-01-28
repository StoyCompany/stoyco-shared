// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stoy_shop_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoyShopCategoryModel _$StoyShopCategoryModelFromJson(
        Map<String, dynamic> json) =>
    StoyShopCategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      benefits: (json['benefits'] as List<dynamic>?)
          ?.map((e) => CategoryBenefitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      brands: (json['brands'] as List<dynamic>?)
          ?.map((e) => CategoryBrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoyShopCategoryModelToJson(
        StoyShopCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'benefits': instance.benefits,
      'brands': instance.brands,
    };

CategoryBenefitModel _$CategoryBenefitModelFromJson(
        Map<String, dynamic> json) =>
    CategoryBenefitModel(
      type: json['type'] as String?,
      selected: json['selected'] as bool?,
    );

Map<String, dynamic> _$CategoryBenefitModelToJson(
        CategoryBenefitModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'selected': instance.selected,
    };

CategoryBrandModel _$CategoryBrandModelFromJson(Map<String, dynamic> json) =>
    CategoryBrandModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$CategoryBrandModelToJson(CategoryBrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
