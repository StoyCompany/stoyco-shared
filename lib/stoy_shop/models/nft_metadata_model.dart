import 'package:json_annotation/json_annotation.dart';

part 'nft_metadata_model.g.dart';

/// Represents NFT metadata fetched from metadataUri.
///
/// Contains detailed information about an NFT including name, description,
/// image, and custom attributes.
@JsonSerializable()
class NftMetadataModel {
  const NftMetadataModel({
    this.name,
    this.description,
    this.image,
    this.attributes,
  });

  factory NftMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$NftMetadataModelFromJson(json);

  final String? name;
  final String? description;
  final String? image;
  final List<NftAttributeModel>? attributes;

  Map<String, dynamic> toJson() => _$NftMetadataModelToJson(this);

  NftMetadataModel copyWith({
    String? name,
    String? description,
    String? image,
    List<NftAttributeModel>? attributes,
  }) =>
      NftMetadataModel(
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        attributes: attributes ?? this.attributes,
      );

  String? getAttributeValue(String traitType) {
    final attribute = attributes?.firstWhere(
      (attr) => attr.traitType == traitType,
      orElse: () => const NftAttributeModel(),
    );
    return attribute?.value?.toString();
  }
}

/// Represents an attribute in NFT metadata.
@JsonSerializable()
class NftAttributeModel {
  const NftAttributeModel({
    this.traitType,
    this.value,
  });

  factory NftAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$NftAttributeModelFromJson(json);

  @JsonKey(name: 'trait_type')
  final String? traitType;
  
  final dynamic value;

  Map<String, dynamic> toJson() => _$NftAttributeModelToJson(this);

  NftAttributeModel copyWith({
    String? traitType,
    dynamic value,
  }) =>
      NftAttributeModel(
        traitType: traitType ?? this.traitType,
        value: value ?? this.value,
      );
}
