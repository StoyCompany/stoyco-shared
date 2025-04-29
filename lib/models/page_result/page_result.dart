import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'page_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageResult<T> {
  factory PageResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PageResultFromJson(json, fromJsonT);

  const PageResult({
    this.pageNumber,
    this.pageSize,
    this.totalItems,
    this.totalPages,
    this.updatedAt,
    this.items,
  });
  final int? pageNumber;
  final int? pageSize;
  final int? totalItems;
  final DateTime? updatedAt;
  final int? totalPages;

  final List<T>? items;

  @override
  String toString() =>
      'PageResult(pageNumber: $pageNumber, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages, updatedAt: $updatedAt, items: $items)';

  Map<String, dynamic> toJson(
    Object Function(T value) toJsonT,
  ) =>
      _$PageResultToJson(this, toJsonT);

  PageResult<T> copyWith({
    int? pageNumber,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    DateTime? updatedAt,
    List<T>? items,
  }) =>
      PageResult<T>(
        pageNumber: pageNumber ?? this.pageNumber,
        pageSize: pageSize ?? this.pageSize,
        totalItems: totalItems ?? this.totalItems,
        totalPages: totalPages ?? this.totalPages,
        updatedAt: updatedAt ?? this.updatedAt,
        items: items ?? this.items,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PageResult<T>) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(
      other.toJson((value) => value as Object),
      toJson((value) => value as Object),
    );
  }

  @override
  int get hashCode =>
      pageNumber.hashCode ^
      pageSize.hashCode ^
      totalItems.hashCode ^
      totalPages.hashCode ^
      updatedAt.hashCode ^
      items.hashCode;
}
