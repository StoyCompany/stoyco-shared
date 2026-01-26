import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/stoy_shop/models/nft_metadata_model.dart';

part 'minted_nft_model.g.dart';

/// Represents a minted NFT owned by a user.
///
/// Contains blockchain information, metadata, and ownership details
/// for NFTs that have been minted to a specific user's wallet.
@JsonSerializable()
class MintedNftModel {
  const MintedNftModel({
    this.id,
    this.holderAddress,
    this.collectionId,
    this.contractAddress,
    this.tokenId,
    this.txHash,
    this.metadataUri,
    this.imageUri,
    this.metadata,
    this.tags,
    this.burned,
    this.isViewed,
    this.mintSerial,
    this.tokenStandard,
    this.createdAt,
    this.updatedAt,
  });

  factory MintedNftModel.fromJson(Map<String, dynamic> json) =>
      _$MintedNftModelFromJson(json);

  /// Unique identifier for this minted NFT.
  final String? id;

  /// Wallet address of the NFT holder.
  final String? holderAddress;

  /// Collection ID this NFT belongs to.
  final int? collectionId;

  /// Smart contract address on the blockchain.
  final String? contractAddress;

  /// Token ID on the blockchain.
  final int? tokenId;

  /// Transaction hash of the mint operation.
  final String? txHash;

  /// URI to fetch additional metadata.
  final String? metadataUri;

  /// URI to the NFT image.
  final String? imageUri;

  /// Embedded NFT metadata including name, description, and attributes.
  final NftMetadataModel? metadata;

  /// Tags associated with this NFT.
  final List<String>? tags;

  /// Whether this NFT has been burned.
  final bool? burned;

  /// Whether the user has viewed this NFT.
  final bool? isViewed;

  /// Mint serial number (e.g., "27/50" - this token is #27 of 50).
  final String? mintSerial;

  /// Token standard (e.g., "ERC-721").
  final String? tokenStandard;

  /// When this NFT was minted.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$MintedNftModelToJson(this);

  MintedNftModel copyWith({
    String? id,
    String? holderAddress,
    int? collectionId,
    String? contractAddress,
    int? tokenId,
    String? txHash,
    String? metadataUri,
    String? imageUri,
    NftMetadataModel? metadata,
    List<String>? tags,
    bool? burned,
    bool? isViewed,
    String? mintSerial,
    String? tokenStandard,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      MintedNftModel(
        id: id ?? this.id,
        holderAddress: holderAddress ?? this.holderAddress,
        collectionId: collectionId ?? this.collectionId,
        contractAddress: contractAddress ?? this.contractAddress,
        tokenId: tokenId ?? this.tokenId,
        txHash: txHash ?? this.txHash,
        metadataUri: metadataUri ?? this.metadataUri,
        imageUri: imageUri ?? this.imageUri,
        metadata: metadata ?? this.metadata,
        tags: tags ?? this.tags,
        burned: burned ?? this.burned,
        isViewed: isViewed ?? this.isViewed,
        mintSerial: mintSerial ?? this.mintSerial,
        tokenStandard: tokenStandard ?? this.tokenStandard,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  /// Whether this NFT is ERC-721 standard.
  bool get isErc721 => tokenStandard == 'ERC-721';

  /// Whether this NFT is still active (not burned).
  bool get isActive => !(burned ?? false);

  /// Extracts the current mint number from mintSerial (e.g., "27" from "27/50").
  int? get mintNumber {
    if (mintSerial == null) return null;
    final parts = mintSerial!.split('/');
    if (parts.isEmpty) return null;
    return int.tryParse(parts[0]);
  }

  /// Extracts the max supply from mintSerial (e.g., "50" from "27/50").
  int? get maxSupply {
    if (mintSerial == null) return null;
    final parts = mintSerial!.split('/');
    if (parts.length < 2) return null;
    return int.tryParse(parts[1]);
  }
}
