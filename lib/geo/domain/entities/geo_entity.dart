import 'package:stoyco_shared/geo/data/geo_location_dto/geo_location_dto.dart';

class GeoEntity {
  factory GeoEntity.fromDto(GeoLocationDto dto) => GeoEntity(
        id: dto.id ?? '',
        type: dto.type ?? '',
        name: dto.attributes?.name ?? '',
        lada: dto.attributes?.lada ?? '',
        countryCode: dto.attributes?.countryCode ?? '',
      );

  GeoEntity({
    required this.id,
    required this.type,
    required this.name,
    required this.lada,
    required this.countryCode,
  });

  final String id;
  final String type;
  final String name;
  final String lada;
  final String countryCode;

  @override
  String toString() {
    return name;
  }
}
