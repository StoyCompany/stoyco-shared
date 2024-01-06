import 'package:intl_phone_field/countries.dart';

/// A class that represents a phone number.
///
/// It contains a [Country] and a [String] number.
class PhoneNumber {
  /// The selected country of the phone number.
  Country? selectedCountry;

  /// The number of the phone number.
  String? number;

  /// Creates a [PhoneNumber].
  PhoneNumber({
    this.selectedCountry,
    this.number,
  });

  /// Creates a copy of this [PhoneNumber] but with the given fields replaced with the new values.
  PhoneNumber copyWith({
    Country? selectedCountry,
    String? phoneNumber,
  }) {
    return PhoneNumber(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      number: phoneNumber ?? number,
    );
  }

  /// Returns true if the phone number is valid.
  ///
  /// A phone number is valid if it has a country and a number.
  bool get isValid {
    if (number == null || selectedCountry == null) {
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

  /// Returns true if the country of the phone number is valid.
  bool get isValidCountry {
    return selectedCountry != null;
  }

  /// Returns true if the number of the phone number is valid.
  bool get isValidNumber {
    if (number!.isEmpty) {
      return false;
    } else if (number!.length < selectedCountry!.minLength) {
      return false;
    } else if (number!.length > selectedCountry!.maxLength) {
      return false;
    }
    return true;
  }

  /// Returns true if the number of the phone number is empty.
  bool get numberIsEmpty {
    return number != null && number!.isEmpty;
  }

  /// Returns true if the country of the phone number is empty.

  bool get countryIsEmpty {
    return selectedCountry == null;
  }
}
