import 'package:json_annotation/json_annotation.dart';
import 'donate_result.dart';

part 'donate_response.g.dart';

/// Represents the full response for a donate operation, including error info and the result data.
///
/// Example:
/// ```dart
/// final response = DonateResponse.fromJson(json);
/// final result = response.data;
/// ```
@JsonSerializable()
class DonateResponse {
  const DonateResponse({
    this.error,
    this.messageError,
    this.tecMessageError,
    this.count,
    this.data,
  });

  factory DonateResponse.fromJson(Map<String, dynamic> json) => _$DonateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DonateResponseToJson(this);

  /// Error code (e.g. -1 for no error)
  final int? error;
  /// User-facing error message
  final String? messageError;
  /// Technical error message
  final String? tecMessageError;
  /// Count or status code
  final int? count;
  /// The actual donation result data
  final DonateResultModel? data;
}

