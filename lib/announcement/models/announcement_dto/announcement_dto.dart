import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'configuration.dart';
import 'content.dart';

part 'announcement_dto.g.dart';

@JsonSerializable()
class AnnouncementDto {
  final String? id;
  @JsonKey(name: 'content_type')
  final String? contentType;
  final String? title;
  @JsonKey(name: 'short_description')
  final String? shortDescription;
  final Content? content;
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @JsonKey(name: 'url_principal_image')
  final String? urlPrincipalImage;
  final String? state;
  @JsonKey(name: 'is_closed_campaign')
  final bool? isClosedCampaign;
  @JsonKey(name: 'published_date')
  final String? publishedDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final Configuration? configuration;

  const AnnouncementDto({
    this.id,
    this.contentType,
    this.title,
    this.shortDescription,
    this.content,
    this.createdBy,
    this.urlPrincipalImage,
    this.state,
    this.isClosedCampaign,
    this.publishedDate,
    this.endDate,
    this.configuration,
  });

  @override
  String toString() {
    return 'AnnouncementDto(id: $id, contentType: $contentType, title: $title, shortDescription: $shortDescription, content: $content, createdBy: $createdBy, urlPrincipalImage: $urlPrincipalImage, state: $state, isClosedCampaign: $isClosedCampaign, publishedDate: $publishedDate, endDate: $endDate, configuration: $configuration)';
  }

  factory AnnouncementDto.fromJson(Map<String, dynamic> json) {
    return _$AnnouncementDtoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AnnouncementDtoToJson(this);

  AnnouncementDto copyWith({
    String? id,
    String? contentType,
    String? title,
    String? shortDescription,
    Content? content,
    String? createdBy,
    String? urlPrincipalImage,
    String? state,
    bool? isClosedCampaign,
    String? publishedDate,
    String? endDate,
    Configuration? configuration,
  }) {
    return AnnouncementDto(
      id: id ?? this.id,
      contentType: contentType ?? this.contentType,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      content: content ?? this.content,
      createdBy: createdBy ?? this.createdBy,
      urlPrincipalImage: urlPrincipalImage ?? this.urlPrincipalImage,
      state: state ?? this.state,
      isClosedCampaign: isClosedCampaign ?? this.isClosedCampaign,
      publishedDate: publishedDate ?? this.publishedDate,
      endDate: endDate ?? this.endDate,
      configuration: configuration ?? this.configuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AnnouncementDto) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      contentType.hashCode ^
      title.hashCode ^
      shortDescription.hashCode ^
      content.hashCode ^
      createdBy.hashCode ^
      urlPrincipalImage.hashCode ^
      state.hashCode ^
      isClosedCampaign.hashCode ^
      publishedDate.hashCode ^
      endDate.hashCode ^
      configuration.hashCode;
}
