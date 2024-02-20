import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
class UserDTO extends Equatable {
  UserDTO({
    this.photo,
    this.stripeCustomerId,
    this.walletAdress,
    this.firstName,
    this.lastName,
    this.numEventsPurchased,
    this.id,
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.country,
    this.typeDocument,
    this.document,
    this.roles,
    this.createdAt,
    this.changePasswordDate,
    this.verifiedEmail,
    this.isUserTest,
    this.provider,
    this.uidevice,
    this.birthDate,
    this.gender,
    this.nickName,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  @HiveField(0)
  final String? photo;
  @HiveField(1)
  final String? stripeCustomerId;
  @HiveField(2)
  final String? walletAdress;
  @HiveField(3)
  final String? firstName;
  @HiveField(4)
  final String? lastName;
  @HiveField(5)
  final int? numEventsPurchased;
  @HiveField(6)
  final String? id;
  @HiveField(7)
  final String? uid;
  @HiveField(8)
  final String? name;
  @HiveField(9)
  final String? email;
  @HiveField(10)
  final String? phoneNumber;
  @HiveField(11)
  final String? country;
  @HiveField(12)
  final String? typeDocument;
  @HiveField(13)
  final String? document;
  @HiveField(14)
  final List<String>? roles;
  @HiveField(15)
  final String? createdAt;
  @HiveField(16)
  final String? changePasswordDate;
  @HiveField(17)
  final bool? verifiedEmail;
  @HiveField(18)
  final bool? isUserTest;
  @HiveField(19)
  final String? provider;
  @HiveField(20)
  final String? uidevice;
  @HiveField(21)
  final String? birthDate;
  @HiveField(22)
  final String? gender;
  @HiveField(23)
  final String? nickName;

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);

  //copyWith
  UserDTO copyWith({
    String? photo,
    String? stripeCustomerId,
    String? walletAdress,
    String? firstName,
    String? lastName,
    int? numEventsPurchased,
    String? id,
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? country,
    String? typeDocument,
    String? document,
    List<String>? roles,
    String? createdAt,
    String? changePasswordDate,
    bool? verifiedEmail,
    bool? isUserTest,
    String? provider,
    String? uidevice,
    String? birthDate,
    String? gender,
    String? nickName,
  }) =>
      UserDTO(
        photo: photo ?? this.photo,
        stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
        walletAdress: walletAdress ?? this.walletAdress,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        numEventsPurchased: numEventsPurchased ?? this.numEventsPurchased,
        id: id ?? this.id,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        country: country ?? this.country,
        typeDocument: typeDocument ?? this.typeDocument,
        document: document ?? this.document,
        roles: roles ?? this.roles,
        createdAt: createdAt ?? this.createdAt,
        changePasswordDate: changePasswordDate ?? this.changePasswordDate,
        verifiedEmail: verifiedEmail ?? this.verifiedEmail,
        isUserTest: isUserTest ?? this.isUserTest,
        provider: provider ?? this.provider,
        uidevice: uidevice ?? this.uidevice,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        nickName: nickName ?? this.nickName,
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        photo,
        stripeCustomerId,
        walletAdress,
        firstName,
        lastName,
        numEventsPurchased,
        id,
        uid,
        name,
        email,
        phoneNumber,
        country,
        typeDocument,
        document,
        roles,
        createdAt,
        changePasswordDate,
        verifiedEmail,
        isUserTest,
        provider,
        uidevice,
      ];

  bool get isLogin => uid != '' && uid != null;

  bool get isEmailEmpty =>
      email == null || email!.isEmpty || email == 'empty@empty.com';

  bool get isNickNameEmpty =>
      nickName == null || nickName!.isEmpty || nickName == 'empty';

  bool get isNameEmpty => name == null || name!.isEmpty || name == 'empty';

  //get name
  String get getName {
    if (!isNameEmpty) {
      return name!;
    } else {
      return '';
    }
  }

  //get Email
  String get getEmail {
    if (!isEmailEmpty) {
      return email!;
    } else {
      return '';
    }
  }

  bool compare(UserDTO userModel) =>
      userModel.photo == photo &&
      userModel.stripeCustomerId == stripeCustomerId &&
      userModel.walletAdress == walletAdress &&
      userModel.firstName == firstName &&
      userModel.lastName == lastName &&
      userModel.numEventsPurchased == numEventsPurchased &&
      userModel.id == id &&
      userModel.uid == uid &&
      userModel.name == name &&
      userModel.email == email &&
      userModel.phoneNumber == phoneNumber &&
      userModel.country == country &&
      userModel.typeDocument == typeDocument &&
      userModel.document == document &&
      userModel.roles == roles &&
      userModel.createdAt == createdAt &&
      userModel.changePasswordDate == changePasswordDate &&
      userModel.verifiedEmail == verifiedEmail &&
      userModel.isUserTest == isUserTest &&
      userModel.provider == provider &&
      userModel.uidevice == uidevice &&
      userModel.birthDate == birthDate &&
      userModel.gender == gender &&
      userModel.nickName == nickName;

  bool get isProfileComplete =>
      firstName != null &&
      firstName!.isNotEmpty &&
      lastName != null &&
      lastName!.isNotEmpty &&
      email != null &&
      email!.isNotEmpty &&
      email != 'empty@empty.com' &&
      phoneNumber != null &&
      phoneNumber!.isNotEmpty &&
      birthDate != null &&
      birthDate!.isNotEmpty &&
      nickName != null &&
      nickName!.isNotEmpty &&
      nickName != 'empty' &&
      gender != null &&
      gender!.isNotEmpty;

  bool get isEssentialDataEmpty => email == null || uid == null || id == null;

  bool get isEmpty =>
      firstName == null &&
      lastName == null &&
      name == null &&
      email == null &&
      phoneNumber == null &&
      country == null &&
      birthDate == null &&
      gender == null &&
      nickName == null;
}
