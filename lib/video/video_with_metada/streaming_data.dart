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

  @JsonKey(name: 'VideoId')
  final String? videoId;

  @JsonKey(name: 'Source')
  final StreamSource? source;

  @JsonKey(name: 'Status')
  final String? status;

  @JsonKey(name: 'Ready')
  final bool? ready;

  @JsonKey(name: 'ContentType')
  final String? contentType;

  @JsonKey(name: 'SizeBytes')
  final int? sizeBytes;

  @JsonKey(name: 'Stream')
  final StreamInfo? stream;

  Map<String, dynamic> toJson() => _$StreamingDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StreamSource {
  factory StreamSource.fromJson(Map<String, dynamic> json) =>
      _$StreamSourceFromJson(json);

  const StreamSource({
    this.bucket,
    this.key,
  });

  @JsonKey(name: 'Bucket')
  final String? bucket;

  @JsonKey(name: 'Key')
  final String? key;

  Map<String, dynamic> toJson() => _$StreamSourceToJson(this);
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

  @JsonKey(name: 'Path')
  final String? path;

  @JsonKey(name: 'Version')
  final String? version;

  @JsonKey(name: 'Url')
  final String? url;

  Map<String, dynamic> toJson() => _$StreamInfoToJson(this);
}
