import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'transactions.g.dart';

/// Represents a single Stoycoins transaction record.
///
/// Example:
/// ```dart
/// final tx = TransactionModel.fromJson(json);
/// ```
@JsonSerializable()
class TransactionModel {
/// Represents a transaction model with various transaction-related properties.
///
/// This is a constant constructor for the TransactionModel class, which initializes
/// an instance of the model with optional parameters for each transaction property.
  const TransactionModel({
    // Unique identifier for the transaction
    this.transactionId,
    // Identifier of the user who initiated the transaction
    this.userId,
    // Points involved in the transaction
    this.points,
    // Current state of the transaction
    this.state,
    // Source of the transaction
    this.source,
    // Reference ID associated with the transaction
    this.referenceId,
    // Timestamp when the transaction was created
    this.createdAt,
    // Timestamp when the transaction was last updated
    this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  final String? transactionId;
  final String? userId;
  final int? points;
  final String? state;
  final String? source;
  final String? referenceId;
  final String? createdAt;
  final String? updatedAt;

  /// Returns a copy of this model with updated fields.
  TransactionModel copyWith({
    String? transactionId,
    String? userId,
    int? points,
    String? state,
    String? source,
    String? referenceId,
    String? createdAt,
    String? updatedAt,
  }) => TransactionModel(
    transactionId: transactionId ?? this.transactionId,
    userId: userId ?? this.userId,
    points: points ?? this.points,
    state: state ?? this.state,
    source: source ?? this.source,
    referenceId: referenceId ?? this.referenceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  String toString() =>
      'TransactionModel(transactionId: $transactionId, userId: $userId, points: $points, state: $state, source: $source, referenceId: $referenceId, createdAt: $createdAt, updatedAt: $updatedAt)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! TransactionModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      transactionId.hashCode ^
      userId.hashCode ^
      points.hashCode ^
      state.hashCode ^
      source.hashCode ^
      referenceId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

