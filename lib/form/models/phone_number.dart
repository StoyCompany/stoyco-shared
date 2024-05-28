import 'package:intl_phone_field/countries.dart';

/// A class that represents a phone number.
///
/// It contains a [Country] and a [String] number.
class PhoneNumber {

  /// Creates a [PhoneNumber].
  PhoneNumber({
    this.selectedCountry,
    this.number,
  });
  /// The selected country of the phone number.
  Country? selectedCountry;

  /// The number of the phone number.
  String? number;

  /// Creates a copy of this [PhoneNumber] but with the given fields replaced with the new values.
  PhoneNumber copyWith({
    Country? selectedCountry,
    String? phoneNumber,
  }) => PhoneNumber(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      number: phoneNumber ?? number,
    );

  /// Returns true if the phone number is valid.
  ///
  /// A phone number is valid if it has a country and a number.
  bool get isValid {
    if (isValidCountry && number == null) {
      return false;
    } else if (number!.isEmpty) {
      return false;
    } else if (number!.length < selectedCountry!.minLength) {
      return false;
    } else if (number!.length > selectedCountry!.maxLength) {
      return false;
    }
    return true;
  }

  /// Returns true if the country of the phone number is valid.
  bool get isValidCountry => selectedCountry != null;

  /// Returns true if the number of the phone number is valid.
  bool get isValidNumber {
    if (number == null) {
      return true;
    } else if (number!.isEmpty) {
      return false;
    } else if (number!.length < selectedCountry!.minLength) {
      return false;
    } else if (number!.length > selectedCountry!.maxLength) {
      return false;
    }
    return true;
  }

  /// Returns true if the number of the phone number is empty.
  bool get numberIsEmpty => number != null && number!.isEmpty;

  /// Returns true if the country of the phone number is empty.

  bool get countryIsEmpty => selectedCountry == null;
}
