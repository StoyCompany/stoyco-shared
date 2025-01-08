import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_location_info.g.dart';

@JsonSerializable()
class UserLocationInfo {
  factory UserLocationInfo.fromJson(Map<String, dynamic> json) =>
      _$UserLocationInfoFromJson(json);

  const UserLocationInfo({
    this.countryName,
    this.countryCode,
    this.lada,
    this.cityName,
  });
  @JsonKey(name: 'CountryName')
  final String? countryName;
  @JsonKey(name: 'CountryCode')
  final String? countryCode;
  @JsonKey(name: 'Lada')
  final String? lada;
  @JsonKey(name: 'CityName')
  final String? cityName;

  @override
  String toString() =>
      'UserLocationInfo(countryName: $countryName, countryCode: $countryCode, lada: $lada, cityName: $cityName)';

  Map<String, dynamic> toJson() => _$UserLocationInfoToJson(this);

  UserLocationInfo copyWith({
    String? countryName,
    String? countryCode,
    String? lada,
    String? cityName,
  }) =>
      UserLocationInfo(
        countryName: countryName ?? this.countryName,
        countryCode: countryCode ?? this.countryCode,
        lada: lada ?? this.lada,
        cityName: cityName ?? this.cityName,
      );

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! UserLocationInfo) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      countryName.hashCode ^
      countryCode.hashCode ^
      lada.hashCode ^
      cityName.hashCode;
}
