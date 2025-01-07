import 'package:json_annotation/json_annotation.dart';

part 'attributes.g.dart';

@JsonSerializable()
class Attributes {
  const Attributes({this.name, this.countryCode, this.lada});

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
  final String? name;
  final String? countryCode;
  final String? lada;

  @override
  String toString() =>
      'Attributes(name: $name, countryCode: $countryCode, lada: $lada)';

  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
