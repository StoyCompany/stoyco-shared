// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDTOAdapter extends TypeAdapter<UserDTO> {
  @override
  final int typeId = 6;

  @override
  UserDTO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDTO(
      photo: fields[0] as String?,
      stripeCustomerId: fields[1] as String?,
      walletAdress: fields[2] as String?,
      firstName: fields[3] as String?,
      lastName: fields[4] as String?,
      numEventsPurchased: fields[5] as int?,
      id: fields[6] as String?,
      uid: fields[7] as String?,
      name: fields[8] as String?,
      email: fields[9] as String?,
      phoneNumber: fields[10] as UserPhoneNumber?,
      country: fields[11] as String?,
      typeDocument: fields[12] as String?,
      document: fields[13] as String?,
      roles: (fields[14] as List?)?.cast<String>(),
      createdAt: fields[15] as String?,
      changePasswordDate: fields[16] as String?,
      verifiedEmail: fields[17] as bool?,
      isUserTest: fields[18] as bool?,
      provider: fields[19] as String?,
      uidevice: fields[20] as String?,
      birthDate: fields[21] as String?,
      gender: fields[22] as String?,
      nickName: fields[23] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserDTO obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.photo)
      ..writeByte(1)
      ..write(obj.stripeCustomerId)
      ..writeByte(2)
      ..write(obj.walletAdress)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.numEventsPurchased)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.uid)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.email)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.country)
      ..writeByte(12)
      ..write(obj.typeDocument)
      ..writeByte(13)
      ..write(obj.document)
      ..writeByte(14)
      ..write(obj.roles)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.changePasswordDate)
      ..writeByte(17)
      ..write(obj.verifiedEmail)
      ..writeByte(18)
      ..write(obj.isUserTest)
      ..writeByte(19)
      ..write(obj.provider)
      ..writeByte(20)
      ..write(obj.uidevice)
      ..writeByte(21)
      ..write(obj.birthDate)
      ..writeByte(22)
      ..write(obj.gender)
      ..writeByte(23)
      ..write(obj.nickName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDTOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      photo: json['photo'] as String?,
      stripeCustomerId: json['stripeCustomerId'] as String?,
      walletAdress: json['walletAdress'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      numEventsPurchased: (json['numEventsPurchased'] as num?)?.toInt(),
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] == null
          ? null
          : UserPhoneNumber.fromJson(
              json['phoneNumber'] as Map<String, dynamic>),
      country: json['country'] as String?,
      typeDocument: json['typeDocument'] as String?,
      document: json['document'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] as String?,
      changePasswordDate: json['changePasswordDate'] as String?,
      verifiedEmail: json['verifiedEmail'] as bool?,
      isUserTest: json['isUserTest'] as bool?,
      provider: json['provider'] as String?,
      uidevice: json['uidevice'] as String?,
      birthDate: json['birthDate'] as String?,
      gender: json['gender'] as String?,
      nickName: json['nickName'] as String?,
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'photo': instance.photo,
      'stripeCustomerId': instance.stripeCustomerId,
      'walletAdress': instance.walletAdress,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'numEventsPurchased': instance.numEventsPurchased,
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber?.toJson(),
      'country': instance.country,
      'typeDocument': instance.typeDocument,
      'document': instance.document,
      'roles': instance.roles,
      'createdAt': instance.createdAt,
      'changePasswordDate': instance.changePasswordDate,
      'verifiedEmail': instance.verifiedEmail,
      'isUserTest': instance.isUserTest,
      'provider': instance.provider,
      'uidevice': instance.uidevice,
      'birthDate': instance.birthDate,
      'gender': instance.gender,
      'nickName': instance.nickName,
    };
