// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_phone_number.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPhoneNumberAdapter extends TypeAdapter<UserPhoneNumber> {
  @override
  final int typeId = 7;

  @override
  UserPhoneNumber read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPhoneNumber(
      number: fields[0] as String,
      cca2Country: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserPhoneNumber obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.cca2Country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPhoneNumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
