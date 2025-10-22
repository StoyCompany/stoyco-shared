import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/video/video_with_metada/video_metadata.dart';
import 'package:stoyco_shared/video/video_with_metada/streaming_data.dart';

part 'video_with_metadata.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoWithMetadata {
  factory VideoWithMetadata.fromJson(Map<String, dynamic> json) =>
      _$VideoWithMetadataFromJson(json);

  const VideoWithMetadata({
    this.videoMetadata,
    this.id,
    this.videoUrl,
    this.appUrl,
    this.name,
    this.description,
    this.partnerId,
    this.order,
    this.active,
    this.createAt,
    this.streamingData,
  });
  final VideoMetadata? videoMetadata;
  final String? id;
  final String? videoUrl;
  final String? appUrl;
  final String? name;
  final String? description;
  final String? partnerId;
  final int? order;
  final bool? active;
  final DateTime? createAt;
  final StreamingData? streamingData;

  @override
  String toString() =>
      'VideoWithMetadata(videoMetadata: $videoMetadata, id: $id, videoUrl: $videoUrl, appUrl: $appUrl, name: $name, description: $description, partnerId: $partnerId, order: $order, active: $active, createAt: $createAt, streamingData: $streamingData)';

  Map<String, dynamic> toJson() => _$VideoWithMetadataToJson(this);

  VideoWithMetadata copyWith({
    VideoMetadata? videoMetadata,
    String? id,
    String? videoUrl,
    String? appUrl,
    String? name,
    String? description,
    String? partnerId,
    int? order,
    bool? active,
    DateTime? createAt,
    StreamingData? streamingData,
  }) =>
      VideoWithMetadata(
        videoMetadata: videoMetadata ?? this.videoMetadata,
        id: id ?? this.id,
        videoUrl: videoUrl ?? this.videoUrl,
        appUrl: appUrl ?? this.appUrl,
        name: name ?? this.name,
        description: description ?? this.description,
        partnerId: partnerId ?? this.partnerId,
        order: order ?? this.order,
        active: active ?? this.active,
        createAt: createAt ?? this.createAt,
        streamingData: streamingData ?? this.streamingData,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! VideoWithMetadata) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      videoMetadata.hashCode ^
      id.hashCode ^
      videoUrl.hashCode ^
      appUrl.hashCode ^
      name.hashCode ^
      description.hashCode ^
      partnerId.hashCode ^
      order.hashCode ^
      active.hashCode ^
      createAt.hashCode ^
      streamingData.hashCode;

  /// Gets the best available video URL, preferring streaming URL if available
  String? get bestVideoUrl {
    // Prefer streaming URL if available and ready
    if (streamingData?.ready == true &&
        streamingData?.stream?.url != null &&
        streamingData!.stream!.url!.isNotEmpty) {
      return streamingData!.stream!.url;
    }
    // Fall back to videoUrl
    return videoUrl;
  }
}
