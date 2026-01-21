// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NftMetadataModel _$NftMetadataModelFromJson(Map<String, dynamic> json) =>
    NftMetadataModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => NftAttributeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NftMetadataModelToJson(NftMetadataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'attributes': instance.attributes,
    };

NftAttributeModel _$NftAttributeModelFromJson(Map<String, dynamic> json) =>
    NftAttributeModel(
      traitType: json['trait_type'] as String?,
      value: json['value'],
    );

Map<String, dynamic> _$NftAttributeModelToJson(NftAttributeModel instance) =>
    <String, dynamic>{
      'trait_type': instance.traitType,
      'value': instance.value,
    };
