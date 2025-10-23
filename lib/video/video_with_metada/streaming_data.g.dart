// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streaming_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamingData _$StreamingDataFromJson(Map<String, dynamic> json) =>
    StreamingData(
      videoId: json['videoId'] as String?,
      source: json['source'] == null
          ? null
          : StreamSource.fromJson(json['source'] as Map<String, dynamic>),
      status: json['status'] as String?,
      ready: json['ready'] as bool?,
      contentType: json['contentType'] as String?,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
      stream: json['stream'] == null
          ? null
          : StreamInfo.fromJson(json['stream'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreamingDataToJson(StreamingData instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'source': instance.source?.toJson(),
      'status': instance.status,
      'ready': instance.ready,
      'contentType': instance.contentType,
      'sizeBytes': instance.sizeBytes,
      'stream': instance.stream?.toJson(),
    };

StreamSource _$StreamSourceFromJson(Map<String, dynamic> json) => StreamSource(
      bucket: json['bucket'] as String?,
      key: json['key'] as String?,
    );

Map<String, dynamic> _$StreamSourceToJson(StreamSource instance) =>
    <String, dynamic>{
      'bucket': instance.bucket,
      'key': instance.key,
    };

StreamInfo _$StreamInfoFromJson(Map<String, dynamic> json) => StreamInfo(
      path: json['path'] as String?,
      version: json['version'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$StreamInfoToJson(StreamInfo instance) =>
    <String, dynamic>{
      'path': instance.path,
      'version': instance.version,
      'url': instance.url,
    };
