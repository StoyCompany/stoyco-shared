import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

/// A custom widget for selecting a country prefix.
///
/// This widget extends [StatefulWidget]. It displays a list of countries and allows
/// the user to select a country. The selected country's flag and code are displayed.
class StoycoCountryPrefixIcon extends StatefulWidget {
  /// Creates a [StoycoCountryPrefixIcon].
  ///
  /// The [onCountryChanged] argument is required.
  const StoycoCountryPrefixIcon({super.key, required this.onCountryChanged});

  /// The callback function that is called when the selected country changes.
  final void Function(Country) onCountryChanged;

  @override
  State<StoycoCountryPrefixIcon> createState() =>
      _StoycoCountryPrefixIconState();
}

class _StoycoCountryPrefixIconState extends State<StoycoCountryPrefixIcon> {
  /// The selected country.
  ValueNotifier<Country?> seletectedCountry = ValueNotifier(null);

  //obtener padding con mediaquery
  double getPadding() {
    final size = MediaQuery.of(context).size;
    if (size.width < 400) {
      return 8;
    } else if (size.width < 600) {
      return 16;
    } else {
      return size.width * 0.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) => StatefulBuilder(
              builder: (ctx, setState) => Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getPadding(), vertical: size.height * 0.1),
                child: CountryPickerDialog(
                  languageCode: 'es',
                  style: PickerDialogStyle(
                    countryCodeStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Akkurat Pro',
                      fontWeight: FontWeight.w700,
                    ),
                    countryNameStyle: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Akkurat Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  filteredCountries: countries,
                  searchText: 'Buscar',
                  countryList: countries,
                  selectedCountry: countries.first,
                  onCountryChanged: (Country country) {
                    seletectedCountry.value = country;
                    widget.onCountryChanged.call(country);
                  },
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: ValueListenableBuilder(
          valueListenable: seletectedCountry,
          builder: (BuildContext context, Country? value, Widget? child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(4),
                value != null
                    ? CountryFlag.fromCountryCode(
                        value.code,
                        height: 20,
                        width: 20,
                        borderRadius: 8,
                      )
                    : Container(
                        width: 22,
                        height: 19,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF92929D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                const Gap(4),
                Text(
                  value?.code ?? '__',
                  style: const TextStyle(
                    color: Color(0xFFF2F2FA),
                    fontSize: 16,
                    fontFamily: 'Akkurat Pro',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(4),
                SvgPicture.asset(
                  'packages/stoyco_shared/lib/assets/icons/arrow-down-icon.svg',
                  height: 16,
                  width: 16,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFFF2F2FA), BlendMode.srcIn),
                ),
                const Gap(4),
              ],
            );
          },
        ),
      ),
    );
  }
}
