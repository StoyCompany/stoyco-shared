// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

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
      locationInfo: json['location'] == null
          ? null
          : UserLocationInfo.fromJson(json['location'] as Map<String, dynamic>),
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
      'location': instance.locationInfo?.toJson(),
    };
