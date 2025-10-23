import 'package:json_annotation/json_annotation.dart';

part 'streaming_data.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamingData {
  factory StreamingData.fromJson(Map<String, dynamic> json) =>
      _$StreamingDataFromJson(json);

  const StreamingData({
    this.videoId,
    this.source,
    this.status,
    this.ready,
    this.contentType,
    this.sizeBytes,
    this.stream,
  });

  @JsonKey(name: 'videoId')
  final String? videoId;

  @JsonKey(name: 'source')
  final StreamSource? source;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'ready')
  final bool? ready;

  @JsonKey(name: 'contentType')
  final String? contentType;

  @JsonKey(name: 'sizeBytes')
  final int? sizeBytes;

  @JsonKey(name: 'stream')
  final StreamInfo? stream;

  Map<String, dynamic> toJson() => _$StreamingDataToJson(this);

  @override
  String toString() {
    return 'StreamingData{'
        'videoId: $videoId, '
        'source: $source, '
        'status: $status, '
        'ready: $ready, '
        'contentType: $contentType, '
        'sizeBytes: $sizeBytes, '
        'stream: $stream'
        '}';
  }
}

@JsonSerializable(explicitToJson: true)
class StreamSource {
  factory StreamSource.fromJson(Map<String, dynamic> json) =>
      _$StreamSourceFromJson(json);

  const StreamSource({
    this.bucket,
    this.key,
  });

  @JsonKey(name: 'bucket')
  final String? bucket;

  @JsonKey(name: 'key')
  final String? key;

  Map<String, dynamic> toJson() => _$StreamSourceToJson(this);

  @override
  String toString() {
    return 'StreamSource{'
        'bucket: $bucket, '
        'key: $key'
        '}';
  }
}

@JsonSerializable(explicitToJson: true)
class StreamInfo {
  factory StreamInfo.fromJson(Map<String, dynamic> json) =>
      _$StreamInfoFromJson(json);

  const StreamInfo({
    this.path,
    this.version,
    this.url,
  });

  @JsonKey(name: 'path')
  final String? path;

  @JsonKey(name: 'version')
  final String? version;

  @JsonKey(name: 'url')
  final String? url;

  Map<String, dynamic> toJson() => _$StreamInfoToJson(this);

  @override
  String toString() {
    return 'StreamInfo{'
        'path: $path, '
        'version: $version, '
        'url: $url'
        '}';
  }
}
