import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'market_segment_model.g.dart';

/// Model representing a market segment.
///
/// Market segments are categories used to classify partners and communities
/// based on their industry, genre, or focus area.
@JsonSerializable()
class MarketSegmentModel extends Equatable {
  /// Creates a new [MarketSegmentModel].
  const MarketSegmentModel({
    required this.id,
    required this.name,
  });

  /// Creates a [MarketSegmentModel] from JSON data.
  factory MarketSegmentModel.fromJson(Map<String, dynamic> json) =>
      _$MarketSegmentModelFromJson(json);

  /// Unique identifier for the market segment.
  @JsonKey(name: 'id')
  final String id;

  /// Display name of the market segment.
  @JsonKey(name: 'name')
  final String name;

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() => _$MarketSegmentModelToJson(this);

  /// Creates a copy of this model with updated fields.
  MarketSegmentModel copyWith({
    String? id,
    String? name,
  }) =>
      MarketSegmentModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  @override
  List<Object?> get props => [id, name];
}
