import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_follow_check_response.g.dart';

/// Response model for checking if a user follows a partner.
///
/// Contains the standard API response structure from the
/// `/v1/partner/follow/check` endpoint.
@JsonSerializable()
class PartnerFollowCheckResponse extends Equatable {
  /// Creates a new instance of [PartnerFollowCheckResponse].
  const PartnerFollowCheckResponse({
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });

  /// Creates a [PartnerFollowCheckResponse] from a JSON map.
  factory PartnerFollowCheckResponse.fromJson(Map<String, dynamic> json) =>
      _$PartnerFollowCheckResponseFromJson(json);

  /// Error code from the API. -1 typically means no error.
  final int error;

  /// Human-readable error message.
  final String messageError;

  /// Technical error message for debugging.
  final String tecMessageError;

  /// Count field from the API response.
  final int count;

  /// The actual follow status as a boolean.
  /// true means the user is following the partner,
  /// false means the user is not following the partner.
  final bool data;

  /// Converts this [PartnerFollowCheckResponse] to a JSON map.
  Map<String, dynamic> toJson() => _$PartnerFollowCheckResponseToJson(this);

  /// Whether the user is currently following the partner.
  /// This is a convenience getter that returns the [data] field.
  bool get isFollowing => data;

  /// Creates a copy of this [PartnerFollowCheckResponse] with the given fields replaced.
  PartnerFollowCheckResponse copyWith({
    int? error,
    String? messageError,
    String? tecMessageError,
    int? count,
    bool? data,
  }) {
    return PartnerFollowCheckResponse(
      error: error ?? this.error,
      messageError: messageError ?? this.messageError,
      tecMessageError: tecMessageError ?? this.tecMessageError,
      count: count ?? this.count,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props =>
      [error, messageError, tecMessageError, count, data];
}
