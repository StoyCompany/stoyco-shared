import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic API response model for endpoints returning a single data object.
///
/// Example:
/// ```dart
/// final response = ApiResponse<BalanceModel>.fromJson(json, BalanceModel.fromJson);
/// final balance = response.data;
/// ```
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({
    this.error,
    this.messageError,
    this.tecMessageError,
    this.count,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) => _$ApiResponseToJson(this, toJsonT);

  final int? error;
  final String? messageError;
  final String? tecMessageError;
  final int? count;
  final T? data;
}
