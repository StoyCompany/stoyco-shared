import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_phone_number.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class UserPhoneNumber extends Equatable {
  const UserPhoneNumber({
    required this.number,
    required this.cca2Country,
  });

  factory UserPhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$UserPhoneNumberFromJson(json);

  Map<String, dynamic> toJson() => _$UserPhoneNumberToJson(this);

  @JsonKey(name: 'number')
  @HiveField(0)
  final String number;

  @JsonKey(name: 'cca2Country')
  @HiveField(1)
  final String cca2Country;

  @override
  List<Object> get props => [number, cca2Country];
}
