import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';

class StoycoCountryPrefixIcon extends StatefulWidget {
  final void Function(Country) onCountryChanged;
  const StoycoCountryPrefixIcon({super.key, required this.onCountryChanged});

  @override
  State<StoycoCountryPrefixIcon> createState() =>
      _StoycoCountryPrefixIconState();
}

class _StoycoCountryPrefixIconState extends State<StoycoCountryPrefixIcon> {
  ValueNotifier<Country?> seletectedCountry = ValueNotifier(null);
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
                    horizontal: size.width * 0.3, vertical: size.height * 0.1),
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
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    value?.flag ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    value?.code ?? '__',
                    style: const TextStyle(
                      color: Color(0xFFF2F2FA),
                      fontSize: 16,
                      fontFamily: 'Akkurat Pro',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: SvgPicture.asset(
                        'assets/icons/keyboard_arrow_down_white_18dp.svg',
                        height: 8,
                        width: 8,
                        colorFilter: const ColorFilter.mode(
                            Color(0xFFF2F2FA), BlendMode.srcIn),
                      )),
                ],
              );
            }),
      ),
    );
  }
}
