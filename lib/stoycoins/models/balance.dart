import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'balance.g.dart';

/// Represents a user's balance and level information.
///
/// Example:
/// ```dart
/// final balance = BalanceModel.fromJson(json);
/// ```
@JsonSerializable()
class BalanceModel {
  const BalanceModel({
    this.userId,
    this.availableBalance,
    this.totalBalance,
    this.pendingWithdrawals,
    this.currentLevelName,
    this.currentLevelCode,
    this.currentLevelIconUrl,
    this.pointsToNextLevel,
    this.nextLevelName,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) =>
      _$BalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceModelToJson(this);

  final String? userId;
  final int? availableBalance;
  final int? totalBalance;
  final int? pendingWithdrawals;
  final String? currentLevelName;
  final String? currentLevelCode;
  final String? currentLevelIconUrl;
  final int? pointsToNextLevel;
  final String? nextLevelName;

  /// Returns a copy of this model with updated fields.
  BalanceModel copyWith({
    String? userId,
    int? availableBalance,
    int? totalBalance,
    int? pendingWithdrawals,
    String? currentLevelName,
    String? currentLevelCode,
    String? currentLevelIconUrl,
    int? pointsToNextLevel,
    String? nextLevelName,
  }) =>
      BalanceModel(
        userId: userId ?? this.userId,
        availableBalance: availableBalance ?? this.availableBalance,
        totalBalance: totalBalance ?? this.totalBalance,
        pendingWithdrawals: pendingWithdrawals ?? this.pendingWithdrawals,
        currentLevelName: currentLevelName ?? this.currentLevelName,
        currentLevelCode: currentLevelCode ?? this.currentLevelCode,
        currentLevelIconUrl: currentLevelIconUrl ?? this.currentLevelIconUrl,
        pointsToNextLevel: pointsToNextLevel ?? this.pointsToNextLevel,
        nextLevelName: nextLevelName ?? this.nextLevelName,
      );

  @override
  String toString() =>
      'BalanceModel(userId: $userId, availableBalance: $availableBalance, totalBalance: $totalBalance, pendingWithdrawals: $pendingWithdrawals, currentLevelName: $currentLevelName, currentLevelCode: $currentLevelCode, currentLevelIconUrl: $currentLevelIconUrl, pointsToNextLevel: $pointsToNextLevel, nextLevelName: $nextLevelName)';

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! BalanceModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      availableBalance.hashCode ^
      totalBalance.hashCode ^
      pendingWithdrawals.hashCode ^
      currentLevelName.hashCode ^
      currentLevelCode.hashCode ^
      currentLevelIconUrl.hashCode ^
      pointsToNextLevel.hashCode ^
      nextLevelName.hashCode;
}