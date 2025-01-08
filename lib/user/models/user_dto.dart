import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:stoyco_shared/user/models/user_location_info/user_location_info.dart';
import 'package:stoyco_shared/user/models/user_phone_number.dart';

part 'user_dto.g.dart';

@JsonSerializable(explicitToJson: true)

/// Represents a Data Transfer Object (DTO) for a user.
/// This class is used for serializing and deserializing user data.
/// It implements the [Equatable] class for easy equality comparisons.
/// The class is annotated with [HiveType] and [JsonSerializable] to enable serialization with Hive and JSON.
class UserDTO extends Equatable {
  /// Creates a new instance of [UserDTO].
  const UserDTO({
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
    this.locationInfo,
  });

  /// Creates a new instance of [UserDTO] from a JSON map.
  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  /// The user's photo.
  final String? photo;

  /// The user's Stripe customer ID.
  final String? stripeCustomerId;

  /// The user's wallet address.
  final String? walletAdress;

  /// The user's first name.
  final String? firstName;

  /// The user's last name.
  final String? lastName;

  /// The number of events purchased by the user.
  final int? numEventsPurchased;

  /// The user's ID.
  final String? id;

  /// The user's UID.
  final String? uid;

  /// The user's name.
  final String? name;

  /// The user's email.
  final String? email;

  /// The user's phone number.
  @JsonKey(name: 'phoneNumber')
  final UserPhoneNumber? phoneNumber;

  /// The user's country.
  final String? country;

  /// The type of document used by the user.
  final String? typeDocument;

  /// The user's document.
  final String? document;

  /// The roles assigned to the user.
  final List<String>? roles;

  /// The user's creation date.
  final String? createdAt;

  /// The date when the user last changed their password.
  final String? changePasswordDate;

  /// Indicates if the user's email has been verified.
  final bool? verifiedEmail;

  /// Indicates if the user is a test user.
  final bool? isUserTest;

  /// The provider used for authentication.
  final String? provider;

  /// The user's device UID.
  final String? uidevice;

  /// The user's birth date.
  final String? birthDate;

  /// The user's gender.
  final String? gender;

  /// The user's nickname.
  final String? nickName;

  @JsonKey(name: 'location')
  final UserLocationInfo? locationInfo;

  /// Converts the [UserDTO] instance to a JSON map.
  Map<String, dynamic> toJson() => _$UserDTOToJson(this);

  /// Creates a copy of the [UserDTO] instance with the specified properties overridden.
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
    UserPhoneNumber? phoneNumber,
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
    UserLocationInfo? locationInfo,
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
        locationInfo: locationInfo ?? this.locationInfo,
      );

  /// Indicates whether the [UserDTO] instance should be treated as a string when comparing equality.
  @override
  bool get stringify => true;

  /// Returns a list of properties used for equality comparisons.
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
        locationInfo,
      ];

  /// Indicates whether the user is logged in.
  bool get isLogin => uid != '' && uid != null;

  /// Indicates whether the user's email is empty.
  bool get isEmailEmpty =>
      email == null || email!.isEmpty || email == 'empty@empty.com';

  /// Indicates whether the user's nickname is empty.
  bool get isNickNameEmpty =>
      nickName == null || nickName!.isEmpty || nickName == 'empty';

  /// Indicates whether the user's name is empty.
  bool get isNameEmpty => name == null || name!.isEmpty || name == 'empty';

  /// Returns the user's name. If the name is empty, an empty string is returned.
  String get getName {
    if (!isNameEmpty) {
      return name!;
    } else {
      return '';
    }
  }

  /// Returns the user's email. If the email is empty, an empty string is returned.
  String get getEmail {
    if (!isEmailEmpty) {
      return email!;
    } else {
      return '';
    }
  }

  /// Compares this [UserDTO] instance with another [UserDTO] instance for equality.
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
      userModel.nickName == nickName &&
      userModel.locationInfo == locationInfo;

  /// Indicates whether the user's profile is complete.
  bool get isProfileComplete =>
      firstName != null &&
      firstName!.isNotEmpty &&
      lastName != null &&
      lastName!.isNotEmpty &&
      email != null &&
      email!.isNotEmpty &&
      email != 'empty@empty.com' &&
      phoneNumber != null &&
      phoneNumber!.number.isNotEmpty &&
      phoneNumber!.cca2Country.isNotEmpty &&
      birthDate != null &&
      birthDate!.isNotEmpty &&
      nickName != null &&
      nickName!.isNotEmpty &&
      nickName != 'empty' &&
      gender != null &&
      gender!.isNotEmpty &&
      locationInfo != null;

  /// Indicates whether the essential user data is empty.
  bool get isEssentialDataEmpty => email == null || uid == null || id == null;

  /// Indicates whether the user data is empty.
  bool get isEmpty =>
      firstName == null &&
      lastName == null &&
      name == null &&
      email == null &&
      phoneNumber == null &&
      country == null &&
      birthDate == null &&
      gender == null &&
      nickName == null &&
      locationInfo == null;
}
