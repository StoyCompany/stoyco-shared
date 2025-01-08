import 'package:json_annotation/json_annotation.dart';

import 'package:stoyco_shared/geo/data/geo_location_dto/attributes.dart';

part 'geo_location_dto.g.dart';

@JsonSerializable()
class GeoLocationDto {
  const GeoLocationDto({this.id, this.type, this.attributes});

  factory GeoLocationDto.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationDtoFromJson(json);
  final String? id;
  final String? type;
  final Attributes? attributes;

  @override
  String toString() =>
      'GeoLocationDto(id: $id, type: $type, attributes: $attributes)';

  Map<String, dynamic> toJson() => _$GeoLocationDtoToJson(this);
}
