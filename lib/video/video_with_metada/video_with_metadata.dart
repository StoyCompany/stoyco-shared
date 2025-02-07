import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/video/video_with_metada/video_metadata.dart';

part 'video_with_metadata.g.dart';

@JsonSerializable()
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
    this.order,
    this.active,
    this.createAt,
  });
  final VideoMetadata? videoMetadata;
  final String? id;
  final String? videoUrl;
  final String? appUrl;
  final String? name;
  final String? description;
  final int? order;
  final bool? active;
  final DateTime? createAt;

  @override
  String toString() =>
      'VideoWithMetadata(videoMetadata: $videoMetadata, id: $id, videoUrl: $videoUrl, appUrl: $appUrl, name: $name, description: $description, order: $order, active: $active, createAt: $createAt)';

  Map<String, dynamic> toJson() => _$VideoWithMetadaToJson(this);

  VideoWithMetadata copyWith({
    VideoMetadata? videoMetadata,
    String? id,
    String? videoUrl,
    String? appUrl,
    String? name,
    String? description,
    int? order,
    bool? active,
    DateTime? createAt,
  }) =>
      VideoWithMetadata(
        videoMetadata: videoMetadata ?? this.videoMetadata,
        id: id ?? this.id,
        videoUrl: videoUrl ?? this.videoUrl,
        appUrl: appUrl ?? this.appUrl,
        name: name ?? this.name,
        description: description ?? this.description,
        order: order ?? this.order,
        active: active ?? this.active,
        createAt: createAt ?? this.createAt,
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
      order.hashCode ^
      active.hashCode ^
      createAt.hashCode;
}
