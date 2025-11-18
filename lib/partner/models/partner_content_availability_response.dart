import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_content_availability_response.g.dart';

/// Wrapper response returned by the
/// `/v1/feed/partner/{partnerId}/content-availability` endpoint.
///
/// It contains the standard API response metadata plus a nested
/// [PartnerContentAvailabilityData] object with the availability flags
/// for each supported content type.
@JsonSerializable()
class PartnerContentAvailabilityResponse extends Equatable {
  /// Creates a new [PartnerContentAvailabilityResponse] instance.
  const PartnerContentAvailabilityResponse({
    required this.error,
    required this.messageError,
    required this.tecMessageError,
    required this.count,
    required this.data,
  });

  /// Builds a [PartnerContentAvailabilityResponse] from JSON.
  factory PartnerContentAvailabilityResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PartnerContentAvailabilityResponseFromJson(json);

  /// Error code (-1 typically means success/no error).
  final int error;

  /// Human readable error message.
  final String messageError;

  /// Technical error message for debugging.
  final String tecMessageError;

  /// Count field as returned by the API (may represent processed items).
  final int count;

  /// Nested availability data.
  final PartnerContentAvailabilityData data;

  /// Serializes this object to JSON.
  Map<String, dynamic> toJson() =>
      _$PartnerContentAvailabilityResponseToJson(this);

  /// Convenience getter indicating if the request was successful.
  bool get isSuccessful => error == -1 && messageError.isEmpty;

  /// Copy helper.
  PartnerContentAvailabilityResponse copyWith({
    int? error,
    String? messageError,
    String? tecMessageError,
    int? count,
    PartnerContentAvailabilityData? data,
  }) =>
      PartnerContentAvailabilityResponse(
        error: error ?? this.error,
        messageError: messageError ?? this.messageError,
        tecMessageError: tecMessageError ?? this.tecMessageError,
        count: count ?? this.count,
        data: data ?? this.data,
      );

  @override
  List<Object?> get props =>
      [error, messageError, tecMessageError, count, data];
}

/// Nested data structure with availability flags.
@JsonSerializable()
class PartnerContentAvailabilityData extends Equatable {
  /// Creates a new [PartnerContentAvailabilityData] instance.
  const PartnerContentAvailabilityData({
    required this.partnerId,
    required this.news,
    required this.announcements,
    required this.eventsFree,
    required this.otherEvents,
    required this.videos,
    required this.nfts,
    required this.products,
  });

  /// Builds a [PartnerContentAvailabilityData] from JSON.
  factory PartnerContentAvailabilityData.fromJson(Map<String, dynamic> json) =>
      _$PartnerContentAvailabilityDataFromJson(json);

  /// Partner identifier for which availability was queried.
  final String partnerId;

  /// Whether news content exists.
  final bool news;

  /// Whether announcements content exists.
  final bool announcements;

  /// Whether free events exist.
  final bool eventsFree;

  /// Whether other (non-free) events exist.
  final bool otherEvents;

  /// Whether video content exists.
  final bool videos;

  /// Whether NFT content exists.
  final bool nfts;

  /// Whether product content exists.
  final bool products;

  /// Serializes this object to JSON.
  Map<String, dynamic> toJson() => _$PartnerContentAvailabilityDataToJson(this);

  /// Returns true if at least one content type is available.
  bool get hasAnyContent =>
      news ||
      announcements ||
      eventsFree ||
      otherEvents ||
      videos ||
      nfts ||
      products;

  /// Copy helper.
  PartnerContentAvailabilityData copyWith({
    String? partnerId,
    bool? news,
    bool? announcements,
    bool? eventsFree,
    bool? otherEvents,
    bool? videos,
    bool? nfts,
    bool? products,
  }) =>
      PartnerContentAvailabilityData(
        partnerId: partnerId ?? this.partnerId,
        news: news ?? this.news,
        announcements: announcements ?? this.announcements,
        eventsFree: eventsFree ?? this.eventsFree,
        otherEvents: otherEvents ?? this.otherEvents,
        videos: videos ?? this.videos,
        nfts: nfts ?? this.nfts,
        products: products ?? this.products,
      );

  @override
  List<Object?> get props => [
        partnerId,
        news,
        announcements,
        eventsFree,
        otherEvents,
        videos,
        nfts,
        products
      ];
}
