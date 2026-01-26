// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minted_nft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MintedNftModel _$MintedNftModelFromJson(Map<String, dynamic> json) =>
    MintedNftModel(
      id: json['id'] as String?,
      holderAddress: json['holderAddress'] as String?,
      collectionId: (json['collectionId'] as num?)?.toInt(),
      contractAddress: json['contractAddress'] as String?,
      tokenId: (json['tokenId'] as num?)?.toInt(),
      txHash: json['txHash'] as String?,
      metadataUri: json['metadataUri'] as String?,
      imageUri: json['imageUri'] as String?,
      metadata: json['metadata'] == null
          ? null
          : NftMetadataModel.fromJson(json['metadata'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      burned: json['burned'] as bool?,
      isViewed: json['isViewed'] as bool?,
      mintSerial: json['mintSerial'] as String?,
      tokenStandard: json['tokenStandard'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MintedNftModelToJson(MintedNftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'holderAddress': instance.holderAddress,
      'collectionId': instance.collectionId,
      'contractAddress': instance.contractAddress,
      'tokenId': instance.tokenId,
      'txHash': instance.txHash,
      'metadataUri': instance.metadataUri,
      'imageUri': instance.imageUri,
      'metadata': instance.metadata,
      'tags': instance.tags,
      'burned': instance.burned,
      'isViewed': instance.isViewed,
      'mintSerial': instance.mintSerial,
      'tokenStandard': instance.tokenStandard,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
