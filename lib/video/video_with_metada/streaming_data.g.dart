// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamingData _$StreamingDataFromJson(Map<String, dynamic> json) =>
    StreamingData(
      videoId: json['VideoId'] as String?,
      source: json['Source'] == null
          ? null
          : StreamSource.fromJson(json['Source'] as Map<String, dynamic>),
      status: json['Status'] as String?,
      ready: json['Ready'] as bool?,
      contentType: json['ContentType'] as String?,
      sizeBytes: (json['SizeBytes'] as num?)?.toInt(),
      stream: json['Stream'] == null
          ? null
          : StreamInfo.fromJson(json['Stream'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreamingDataToJson(StreamingData instance) =>
    <String, dynamic>{
      'VideoId': instance.videoId,
      'Source': instance.source?.toJson(),
      'Status': instance.status,
      'Ready': instance.ready,
      'ContentType': instance.contentType,
      'SizeBytes': instance.sizeBytes,
      'Stream': instance.stream?.toJson(),
    };

StreamSource _$StreamSourceFromJson(Map<String, dynamic> json) => StreamSource(
      bucket: json['Bucket'] as String?,
      key: json['Key'] as String?,
    );

Map<String, dynamic> _$StreamSourceToJson(StreamSource instance) =>
    <String, dynamic>{
      'Bucket': instance.bucket,
      'Key': instance.key,
    };

StreamInfo _$StreamInfoFromJson(Map<String, dynamic> json) => StreamInfo(
      path: json['Path'] as String?,
      version: json['Version'] as String?,
      url: json['Url'] as String?,
    );

Map<String, dynamic> _$StreamInfoToJson(StreamInfo instance) =>
    <String, dynamic>{
      'Path': instance.path,
      'Version': instance.version,
      'Url': instance.url,
    };
