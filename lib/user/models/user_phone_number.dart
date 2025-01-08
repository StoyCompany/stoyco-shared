import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'user_phone_number.g.dart';

@JsonSerializable()
class UserPhoneNumber extends Equatable {
  const UserPhoneNumber({
    required this.number,
    required this.cca2Country,
  });

  factory UserPhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$UserPhoneNumberFromJson(json);

  Map<String, dynamic> toJson() => _$UserPhoneNumberToJson(this);

  @JsonKey(name: 'number')
  final String number;

  @JsonKey(name: 'cca2Country')
  final String cca2Country;

  @override
  List<Object> get props => [number, cca2Country];
}
