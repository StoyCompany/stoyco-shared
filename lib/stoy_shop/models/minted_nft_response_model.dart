import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/stoy_shop/models/minted_nft_model.dart';

part 'minted_nft_response_model.g.dart';

/// Response wrapper for minted NFT API calls.
///
/// Contains error information and a list of minted NFTs.
@JsonSerializable()
class MintedNftResponseModel {
  const MintedNftResponseModel({
    this.error,
    this.messageError,
    this.tecMessageError,
    this.count,
    this.data,
  });

  factory MintedNftResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MintedNftResponseModelFromJson(json);

  /// Error code (-1 indicates success, positive values indicate errors).
  final int? error;

  /// User-friendly error message.
  final String? messageError;

  /// Technical error message for debugging.
  final String? tecMessageError;

  /// Number of NFTs in the response.
  final int? count;

  /// List of minted NFTs.
  final List<MintedNftModel>? data;

  Map<String, dynamic> toJson() => _$MintedNftResponseModelToJson(this);

  MintedNftResponseModel copyWith({
    int? error,
    String? messageError,
    String? tecMessageError,
    int? count,
    List<MintedNftModel>? data,
  }) =>
      MintedNftResponseModel(
        error: error ?? this.error,
        messageError: messageError ?? this.messageError,
        tecMessageError: tecMessageError ?? this.tecMessageError,
        count: count ?? this.count,
        data: data ?? this.data,
      );

  /// Whether the API call was successful.
  bool get isSuccess => error == -1;

  /// Whether there was an error.
  bool get hasError => !isSuccess;
}
