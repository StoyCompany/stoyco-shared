import 'package:stoyco_shared/announcement/models/announcement_dto/announcement_dto.dart';
import 'package:stoyco_shared/announcement/models/announcement_model.dart';

/// A utility class that provides mapping functionality between [AnnouncementDto]
/// and [AnnouncementModel] objects.
///
/// This mapper facilitates the conversion between data transfer objects (DTOs) used
/// for API communication and domain models used within the application.
///
/// Example:
/// ```dart
/// // Convert from DTO to Model
/// final dto = AnnouncementDto(id: '1', title: 'Announcement');
/// final model = AnnouncementMapper.fromDto(dto);
///
/// // Convert from Model to DTO
/// final model = AnnouncementModel(id: '1', title: 'Announcement');
/// final dto = AnnouncementMapper.toDto(model);
/// ```
class AnnouncementMapper {
  /// Converts an [AnnouncementDto] to an [AnnouncementModel].
  ///
  /// This method transforms the API representation of an announcement
  /// into the domain model used by the application.
  ///
  /// Example:
  /// ```dart
  /// final dto = AnnouncementDto(
  ///   id: '1',
  ///   title: 'Important Announcement',
  ///   urlPrincipalImage: 'https://example.com/image.jpg',
  ///   content: 'This is the content',
  ///   state: 'published',
  /// );
  ///
  /// final model = AnnouncementMapper.fromDto(dto);
  /// print(model.title); // Outputs: Important Announcement
  /// print(model.isPublished); // Outputs: true
  /// ```
  static AnnouncementModel fromDto(AnnouncementDto dto) => AnnouncementModel(
        id: dto.id,
        title: dto.title,
        mainImage: dto.urlPrincipalImage,
        content: dto.content, // Assuming Content has a text property
        shortDescription: dto.shortDescription,
        isDraft: AnnouncementState.isDraft(dto.state),
        isPublished: AnnouncementState.isPublished(dto.state),
        isDeleted: AnnouncementState.isDeleted(dto.state),
        startDate: dto.publishedDate,
        endDate: dto.endDate,
        createdBy: dto.createdBy,
        viewCount: dto.views,
        images: [],
      );

  /// Converts an [AnnouncementModel] to an [AnnouncementDto].
  ///
  /// This method transforms the domain model of an announcement
  /// into the DTO representation used for API communication.
  ///
  /// Example:
  /// ```dart
  /// final model = AnnouncementModel(
  ///   id: '1',
  ///   title: 'Important Announcement',
  ///   mainImage: 'https://example.com/image.jpg',
  ///   content: 'This is the content',
  ///   isPublished: true,
  /// );
  ///
  /// final dto = AnnouncementMapper.toDto(model);
  /// print(dto.title); // Outputs: Important Announcement
  /// print(dto.state); // Outputs: published
  /// ```
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
      views: model.viewCount,
    );
  }

  /// Converts a list of [AnnouncementDto] objects to a list of [AnnouncementModel] objects.
  ///
  /// This is a convenience method for batch conversion of DTOs to domain models.
  ///
  /// Example:
  /// ```dart
  /// final dtoList = [
  ///   AnnouncementDto(id: '1', title: 'First Announcement'),
  ///   AnnouncementDto(id: '2', title: 'Second Announcement'),
  /// ];
  ///
  /// final modelList = AnnouncementMapper.fromDtoList(dtoList);
  /// print(modelList.length); // Outputs: 2
  /// print(modelList[0].title); // Outputs: First Announcement
  /// ```
  static List<AnnouncementModel> fromDtoList(List<AnnouncementDto> dtoList) =>
      dtoList.map((dto) => fromDto(dto)).toList();

  /// Converts a list of [AnnouncementModel] objects to a list of [AnnouncementDto] objects.
  ///
  /// This is a convenience method for batch conversion of domain models to DTOs.
  ///
  /// Example:
  /// ```dart
  /// final modelList = [
  ///   AnnouncementModel(id: '1', title: 'First Announcement'),
  ///   AnnouncementModel(id: '2', title: 'Second Announcement'),
  /// ];
  ///
  /// final dtoList = AnnouncementMapper.toDtoList(modelList);
  /// print(dtoList.length); // Outputs: 2
  /// print(dtoList[0].title); // Outputs: First Announcement
  /// ```
  static List<AnnouncementDto> toDtoList(List<AnnouncementModel> modelList) =>
      modelList.map((model) => toDto(model)).toList();
}
