import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  const Content({this.detail, this.content});
  final String? detail;
  final String? content;

  @override
  String toString() => 'Content(detail: $detail, content: $content)';

  Map<String, dynamic> toJson() => _$ContentToJson(this);

  Content copyWith({
    String? detail,
    String? content,
  }) =>
      Content(
        detail: detail ?? this.detail,
        content: content ?? this.content,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Content) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => detail.hashCode ^ content.hashCode;
}
