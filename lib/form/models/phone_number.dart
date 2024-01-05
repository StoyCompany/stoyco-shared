import 'package:intl_phone_field/countries.dart';

class PhoneNumber {
  Country? selectedCountry;
  String? number;

  PhoneNumber({
    this.selectedCountry,
    this.number,
  });

  PhoneNumber copyWith({
    Country? selectedCountry,
    String? phoneNumber,
  }) {
    return PhoneNumber(
      selectedCountry: selectedCountry ?? this.selectedCountry,
      number: phoneNumber ?? number,
    );
  }

  //phone number is valid if it has a country and a number
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

  bool get isValidCountry {
    return selectedCountry != null;
  }

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

  bool get numberIsEmpty {
    return number != null && number!.isEmpty;
  }

  bool get countryIsEmpty {
    return selectedCountry == null;
  }
}
