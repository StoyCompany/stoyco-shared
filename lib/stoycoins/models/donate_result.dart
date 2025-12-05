import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'donate_result.g.dart';

/// Represents the result of a donation transaction.
///
/// Example:
/// ```dart
/// final result = DonateResultModel.fromJson(json);
/// ```
@JsonSerializable()
class DonateResultModel {
  const DonateResultModel({
    this.transactionId,
    this.newBalance,
    this.transactionState,
    this.currentLevelName,
    this.pointsToNextLevel,
    this.contextResult,
  });

  factory DonateResultModel.fromJson(Map<String, dynamic> json) => _$DonateResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$DonateResultModelToJson(this);

  final String? transactionId;
  final int? newBalance;
  final String? transactionState;
  final String? currentLevelName;
  final int? pointsToNextLevel;
  final DonateContextResultModel? contextResult;

  DonateResultModel copyWith({
    String? transactionId,
    int? newBalance,
    String? transactionState,
    String? currentLevelName,
    int? pointsToNextLevel,
    DonateContextResultModel? contextResult,
  }) => DonateResultModel(
    transactionId: transactionId ?? this.transactionId,
    newBalance: newBalance ?? this.newBalance,
    transactionState: transactionState ?? this.transactionState,
    currentLevelName: currentLevelName ?? this.currentLevelName,
    pointsToNextLevel: pointsToNextLevel ?? this.pointsToNextLevel,
    contextResult: contextResult ?? this.contextResult,
  );

  @override
  String toString() =>
      'DonateResultModel(transactionId: $transactionId, newBalance: $newBalance, transactionState: $transactionState, currentLevelName: $currentLevelName, pointsToNextLevel: $pointsToNextLevel, contextResult: $contextResult)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DonateResultModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      transactionId.hashCode ^
      newBalance.hashCode ^
      transactionState.hashCode ^
      currentLevelName.hashCode ^
      pointsToNextLevel.hashCode ^
      contextResult.hashCode;
}

/// Contextual result for a donation transaction.
@JsonSerializable()
class DonateContextResultModel {
  const DonateContextResultModel({
    this.projectId,
    this.communityOwnerId,
    this.contributedAmount,
    this.status,
    this.message,
  });

  factory DonateContextResultModel.fromJson(Map<String, dynamic> json) => _$DonateContextResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$DonateContextResultModelToJson(this);

  final String? projectId;
  final String? communityOwnerId;
  final int? contributedAmount;
  final String? status;
  final String? message;

  DonateContextResultModel copyWith({
    String? projectId,
    String? communityOwnerId,
    int? contributedAmount,
    String? status,
    String? message,
  }) => DonateContextResultModel(
    projectId: projectId ?? this.projectId,
    communityOwnerId: communityOwnerId ?? this.communityOwnerId,
    contributedAmount: contributedAmount ?? this.contributedAmount,
    status: status ?? this.status,
    message: message ?? this.message,
  );

  @override
  String toString() =>
      'DonateContextResultModel(projectId: $projectId, communityOwnerId: $communityOwnerId, contributedAmount: $contributedAmount, status: $status, message: $message)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! DonateContextResultModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      projectId.hashCode ^
      communityOwnerId.hashCode ^
      contributedAmount.hashCode ^
      status.hashCode ^
      message.hashCode;
}

