import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'new_model.g.dart';

@JsonSerializable()
class NewModel {
  const NewModel({
    this.id,
    this.title,
    this.mainImage,
    this.images,
    this.content,
    this.shortDescription,
    this.isDraft,
    this.isPublished,
    this.isDeleted,
    this.viewCount,
    this.scheduledPublishDate,
    this.draftCreationDate,
    this.lastUpdatedDate,
    this.deletionDate,
    this.cronJobId,
    this.createdBy,
    this.createdAt,
    this.communityOwnerId,
    this.hasAccess,
    this.accessContent,
  });

  factory NewModel.fromJson(Map<String, dynamic> json) =>
      _$NewModelFromJson(json);

  final String? id;
  final String? title;
  final String? mainImage;
  final List<String>? images;
  final String? content;
  final String? shortDescription;
  final bool? isDraft;
  final bool? isPublished;
  final bool? isDeleted;
  final int? viewCount;
  final String? scheduledPublishDate;
  final String? draftCreationDate;
  final String? lastUpdatedDate;
  final dynamic deletionDate;
  final dynamic cronJobId;
  final String? createdBy;
  final String? createdAt;
  final String? communityOwnerId;
  final bool? hasAccess;
  final Map<String, dynamic>? accessContent;

  @override
  String toString() =>
      'NewModel(id: $id, title: $title, mainImage: $mainImage, images: $images, content: $content, shortDescription: $shortDescription, isDraft: $isDraft, isPublished: $isPublished, isDeleted: $isDeleted, viewCount: $viewCount, scheduledPublishDate: $scheduledPublishDate, draftCreationDate: $draftCreationDate, lastUpdatedDate: $lastUpdatedDate, deletionDate: $deletionDate, cronJobId: $cronJobId, createdBy: $createdBy, createdAt: $createdAt, communityOwnerId: $communityOwnerId, hasAccess: $hasAccess, accessContent: $accessContent)';

  Map<String, dynamic> toJson() => _$NewModelToJson(this);

  NewModel copyWith({
    String? id,
    String? title,
    String? mainImage,
    List<String>? images,
    String? content,
    String? shortDescription,
    bool? isDraft,
    bool? isPublished,
    bool? isDeleted,
    int? viewCount,
    String? scheduledPublishDate,
    String? draftCreationDate,
    String? lastUpdatedDate,
    dynamic deletionDate,
    dynamic cronJobId,
    String? createdBy,
    String? createdAt,
    bool? hasAccess,
    Map<String, dynamic>? accessContent,
  }) =>
      NewModel(
        id: id ?? this.id,
        title: title ?? this.title,
        mainImage: mainImage ?? this.mainImage,
        images: images ?? this.images,
        content: content ?? this.content,
        shortDescription: shortDescription ?? this.shortDescription,
        isDraft: isDraft ?? this.isDraft,
        isPublished: isPublished ?? this.isPublished,
        isDeleted: isDeleted ?? this.isDeleted,
        viewCount: viewCount ?? this.viewCount,
        scheduledPublishDate: scheduledPublishDate ?? this.scheduledPublishDate,
        draftCreationDate: draftCreationDate ?? this.draftCreationDate,
        lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
        deletionDate: deletionDate ?? this.deletionDate,
        cronJobId: cronJobId ?? this.cronJobId,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        hasAccess: hasAccess ?? this.hasAccess,
        accessContent: accessContent ?? this.accessContent,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! NewModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      mainImage.hashCode ^
      images.hashCode ^
      content.hashCode ^
      shortDescription.hashCode ^
      isDraft.hashCode ^
      isPublished.hashCode ^
      isDeleted.hashCode ^
      viewCount.hashCode ^
      scheduledPublishDate.hashCode ^
      draftCreationDate.hashCode ^
      lastUpdatedDate.hashCode ^
      deletionDate.hashCode ^
      cronJobId.hashCode ^
      createdBy.hashCode ^
      createdAt.hashCode ^
      hasAccess.hashCode ^
      accessContent.hashCode;
}
