import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/announcement/models/announcement_dto/content.dart';

part 'announcement_model.g.dart';

@JsonSerializable()
class AnnouncementModel {
  const AnnouncementModel({
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
    this.startDate,
    this.endDate,
    this.draftCreationDate,
    this.lastUpdatedDate,
    this.deletionDate,
    this.cronJobId,
    this.createdBy,
    this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);

  final String? id;
  final String? title;
  final String? mainImage;
  final List<String>? images;
  final Content? content;
  final String? shortDescription;
  final bool? isDraft;
  final bool? isPublished;
  final bool? isDeleted;
  final int? viewCount;
  final String? startDate;
  final String? endDate;
  final String? draftCreationDate;
  final String? lastUpdatedDate;
  final dynamic deletionDate;
  final dynamic cronJobId;
  final String? createdBy;
  final String? createdAt;

  bool get isActive => isPublished ?? false;

  @override
  String toString() =>
      'AnnouncementModel(id: $id, title: $title, mainImage: $mainImage, images: $images, content: $content, shortDescription: $shortDescription, isDraft: $isDraft, isPublished: $isPublished, isDeleted: $isDeleted, viewCount: $viewCount, startDate: $startDate, endDate: $endDate, draftCreationDate: $draftCreationDate, lastUpdatedDate: $lastUpdatedDate, deletionDate: $deletionDate, cronJobId: $cronJobId, createdBy: $createdBy, createdAt: $createdAt)';

  Map<String, dynamic> toJson() => _$AnnouncementModelToJson(this);

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? mainImage,
    List<String>? images,
    Content? content,
    String? shortDescription,
    bool? isDraft,
    bool? isPublished,
    bool? isDeleted,
    int? viewCount,
    String? startDate,
    String? endDate,
    String? draftCreationDate,
    String? lastUpdatedDate,
    dynamic deletionDate,
    dynamic cronJobId,
    String? createdBy,
    String? createdAt,
  }) =>
      AnnouncementModel(
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
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        draftCreationDate: draftCreationDate ?? this.draftCreationDate,
        lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
        deletionDate: deletionDate ?? this.deletionDate,
        cronJobId: cronJobId ?? this.cronJobId,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AnnouncementModel) return false;
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
      startDate.hashCode ^
      endDate.hashCode ^
      draftCreationDate.hashCode ^
      lastUpdatedDate.hashCode ^
      deletionDate.hashCode ^
      cronJobId.hashCode ^
      createdBy.hashCode ^
      createdAt.hashCode;
}
