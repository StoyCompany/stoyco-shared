import 'package:stoyco_shared/announcement/models/announcement_dto/announcement_dto.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';

class AnnouncementMapper {
  /// Converts an [AnnouncementDto] to an [AnnouncementModel]
  static AnnouncementModel fromDto(AnnouncementDto dto) => AnnouncementModel(
        id: dto.id,
        title: dto.title,
        mainImage: dto.urlPrincipalImage,
        content: dto.content, // Assuming Content has a text property
        shortDescription: dto.shortDescription,
        isDraft: dto.state?.toLowerCase() == 'draft',
        isPublished: dto.state?.toLowerCase() == 'published',
        isDeleted: dto.state?.toLowerCase() == 'deleted',
        startDate: dto.publishedDate,
        endDate: dto.endDate,
        createdBy: dto.createdBy,
        viewCount: 0,
        images: [],
      );

  /// Converts an [AnnouncementModel] to an [AnnouncementDto]
  static AnnouncementDto toDto(AnnouncementModel model) {
    String? state;
    if (model.isDraft == true) {
      state = 'draft';
    } else if (model.isPublished == true) {
      state = 'published';
    } else if (model.isDeleted == true) {
      state = 'deleted';
    }

    return AnnouncementDto(
      id: model.id,
      title: model.title,
      urlPrincipalImage: model.mainImage,
      content: model.content,
      shortDescription: model.shortDescription,
      state: state,
      createdBy: model.createdBy,
      publishedDate: model.startDate,
      endDate: model.endDate,
    );
  }

  /// Converts a list of [AnnouncementDto] to a list of [AnnouncementModel]
  static List<AnnouncementModel> fromDtoList(List<AnnouncementDto> dtoList) =>
      dtoList.map((dto) => fromDto(dto)).toList();

  /// Converts a list of [AnnouncementModel] to a list of [AnnouncementDto]
  static List<AnnouncementDto> toDtoList(List<AnnouncementModel> modelList) =>
      modelList.map((model) => toDto(model)).toList();
}
