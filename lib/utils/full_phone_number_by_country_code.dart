import 'package:stoyco_shared/form/data/countries.dart';

String getFullPhoneNumber(String? countryCode, String? phoneNumber) {
 if ((countryCode?.isEmpty ?? true) || (phoneNumber?.isEmpty ?? true)) {
    return '';
  }
  try {
    final country = stoycoCountries.firstWhere((c) => c.code == countryCode);
    final dialCode = country.dialCode ?? '';
    if (dialCode.isEmpty) return '';
    return '+$dialCode$phoneNumber';
  } catch (_) {
    return '';
  }
}

