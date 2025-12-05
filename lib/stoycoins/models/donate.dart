import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'donate.g.dart';

/// Represents a donate transaction payload or record.
///
/// Example:
/// ```dart
/// final donate = DonateModel.fromJson(json);
/// ```
@JsonSerializable()
class DonateModel {
  const DonateModel({
    this.senderId,
    this.receiverId,
    this.receiverType,
    this.points,
    this.context,
    this.description,
    this.quantity,
  });

  factory DonateModel.fromJson(Map<String, dynamic> json) => _$DonateModelFromJson(json);
  Map<String, dynamic> toJson() => _$DonateModelToJson(this);

  final String? senderId;
  final String? receiverId;
  final String? receiverType;
  final int? points;
  final DonateContextModel? context;
  final String? description;
  final int? quantity;

  DonateModel copyWith({
    String? senderId,
    String? receiverId,
    String? receiverType,
    int? points,
    DonateContextModel? context,
    String? description,
    int? quantity,
  }) => DonateModel(
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    receiverType: receiverType ?? this.receiverType,
    points: points ?? this.points,
    context: context ?? this.context,
    description: description ?? this.description,
    quantity: quantity ?? this.quantity,
  );

  @override
  String toString() =>
      'DonateModel(senderId: $senderId, receiverId: $receiverId, receiverType: $receiverType, points: $points, context: $context, description: $description, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DonateModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      senderId.hashCode ^
      receiverId.hashCode ^
      receiverType.hashCode ^
      points.hashCode ^
      context.hashCode ^
      description.hashCode ^
      quantity.hashCode;
}

/// Context for a donate transaction, including source, reference, and extra data.
@JsonSerializable()
class DonateContextModel {
  const DonateContextModel({
    this.source,
    this.referenceId,
    this.extraData,
  });

  factory DonateContextModel.fromJson(Map<String, dynamic> json) => _$DonateContextModelFromJson(json);
  Map<String, dynamic> toJson() => _$DonateContextModelToJson(this);

  final String? source;
  final String? referenceId;
  /// Extra data for a donate context, accepts any key-value pairs.
  final Map<String, dynamic>? extraData;

  DonateContextModel copyWith({
    String? source,
    String? referenceId,
    Map<String, dynamic>? extraData,
  }) => DonateContextModel(
    source: source ?? this.source,
    referenceId: referenceId ?? this.referenceId,
    extraData: extraData ?? this.extraData,
  );

  @override
  String toString() =>
      'DonateContextModel(source: $source, referenceId: $referenceId, extraData: $extraData)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DonateContextModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      source.hashCode ^
      referenceId.hashCode ^
      extraData.hashCode;
}
