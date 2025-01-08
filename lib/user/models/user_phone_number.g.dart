// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_phone_number.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPhoneNumber _$UserPhoneNumberFromJson(Map<String, dynamic> json) =>
    UserPhoneNumber(
      number: json['number'] as String,
      cca2Country: json['cca2Country'] as String,
    );

Map<String, dynamic> _$UserPhoneNumberToJson(UserPhoneNumber instance) =>
    <String, dynamic>{
      'number': instance.number,
      'cca2Country': instance.cca2Country,
    };
