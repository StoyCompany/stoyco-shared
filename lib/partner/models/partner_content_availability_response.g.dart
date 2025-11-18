// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_content_availability_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerContentAvailabilityResponse _$PartnerContentAvailabilityResponseFromJson(
        Map<String, dynamic> json) =>
    PartnerContentAvailabilityResponse(
      error: (json['error'] as num).toInt(),
      messageError: json['messageError'] as String,
      tecMessageError: json['tecMessageError'] as String,
      count: (json['count'] as num).toInt(),
      data: PartnerContentAvailabilityData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PartnerContentAvailabilityResponseToJson(
        PartnerContentAvailabilityResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'messageError': instance.messageError,
      'tecMessageError': instance.tecMessageError,
      'count': instance.count,
      'data': instance.data,
    };

PartnerContentAvailabilityData _$PartnerContentAvailabilityDataFromJson(
        Map<String, dynamic> json) =>
    PartnerContentAvailabilityData(
      partnerId: json['partnerId'] as String,
      news: json['news'] as bool,
      announcements: json['announcements'] as bool,
      eventsFree: json['eventsFree'] as bool,
      otherEvents: json['otherEvents'] as bool,
      videos: json['videos'] as bool,
      nfts: json['nfts'] as bool,
      products: json['products'] as bool,
    );

Map<String, dynamic> _$PartnerContentAvailabilityDataToJson(
        PartnerContentAvailabilityData instance) =>
    <String, dynamic>{
      'partnerId': instance.partnerId,
      'news': instance.news,
      'announcements': instance.announcements,
      'eventsFree': instance.eventsFree,
      'otherEvents': instance.otherEvents,
      'videos': instance.videos,
      'nfts': instance.nfts,
      'products': instance.products,
    };
