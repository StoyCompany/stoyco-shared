import 'package:stoyco_shared/form/data/countries.dart';

String getFullPhoneNumber(String? countryCode, String? phoneNumber) {
  if (countryCode == null || countryCode.isEmpty || phoneNumber == null || phoneNumber.isEmpty) {
    return 'User NOT LOGGED';
  }
  try {
    final country = stoycoCountries.firstWhere((c) => c.code == countryCode);
    final dialCode = country.dialCode ?? '';
    if (dialCode.isEmpty) return 'User NOT LOGGED';
    return '+$dialCode$phoneNumber';
  } catch (_) {
    return 'User NOT LOGGED';
  }
}

