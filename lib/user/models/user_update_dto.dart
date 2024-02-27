/// Represents a data transfer object for updating user information.
class UserUpdateDTO {
  /// The unique identifier of the user.
  String? uid;

  /// The name of the user.
  String? name;

  /// The phone number of the user.
  String? phoneNumber;

  /// The first name of the user.
  String? firstName;

  /// The last name of the user.
  String? lastName;

  /// The photo of the user.
  String? photo;

  /// Indicates whether the user's email is verified or not.
  bool? verifyEmail;

  /// The provider of the user.
  String? provider;

  /// The email of the user.
  String? email;

  /// The gender of the user.
  String? gender;

  /// The nickname of the user.
  String? nickName;

  /// The birth date of the user.
  String? birthDate;

  /// Creates a new instance of [UserUpdateDTO].
  UserUpdateDTO({
    this.uid,
    this.name,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.photo,
    this.verifyEmail,
    this.provider,
    this.email,
    this.gender,
    this.nickName,
    this.birthDate,
  });

  /// Creates a new instance of [UserUpdateDTO] from a JSON map.
  UserUpdateDTO.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    photo = json['photo'];
    verifyEmail = json['verifyEmail'];
    provider = json['provider'];
    email = json['email'];
    gender = json['gender'];
    nickName = json['nickName'];
    birthDate = json['birthDate'];
  }

  /// Converts the [UserUpdateDTO] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['photo'] = photo;
    data['verifyEmail'] = verifyEmail;
    data['provider'] = provider;
    data['email'] = email;
    data['gender'] = gender;
    data['nickname'] = nickName;
    data['birthDate'] = birthDate;
    return data;
  }
}
