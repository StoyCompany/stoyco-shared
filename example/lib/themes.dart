import 'package:example/colors.dart';
import 'package:flutter/material.dart';

class Themes {
  static ThemeData stoycoTheme = ThemeData(
    primaryColor: StoycoColors.principal,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: //white
          const MaterialColor(
        0xFFFAFAFA,
        <int, Color>{
          50: Color(0xFFFAFAFA),
          100: Color(0xFFFAFAFA),
          200: Color(0xFFFAFAFA),
          300: Color(0xFFFAFAFA),
          400: Color(0xFFFAFAFA),
          500: Color(0xFFFAFAFA),
          600: Color(0xFFFAFAFA),
          700: Color(0xFFFAFAFA),
          800: Color(0xFFFAFAFA),
          900: Color(0xFFFAFAFA),
        },
      ),
      accentColor: StoycoColors.principal, // Color de resaltado
      errorColor: StoycoColors.error, // Color de error
      brightness: Brightness.dark, // Brillo general
    ),
    fontFamily: 'Akkurat Pro',
    unselectedWidgetColor: StoycoColors.principal,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 18,
        bottom: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF252836),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF252836),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color(0xFF252836),
        ),
      ),
      hintStyle: const TextStyle(
        color: Color(0xFF92929D),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Akkurat Pro',
      ),
      // label inicia 8 puntos de la izquierda
      labelStyle: const TextStyle(
        // #92929D
        color: Color(0xFF92929D),
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Akkurat Pro',
      ),
      floatingLabelStyle: TextStyle(
        color: StoycoColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Akkurat Pro',
      ),
      counterStyle: TextStyle(
        color: StoycoColors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Akkurat Pro',
      ),
      errorStyle: TextStyle(
        color: StoycoColors.error,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Akkurat Pro',
      ),
      // el error de borde debe ser una sombra alrededor del borde pero la linea no debe cambiar de color
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: StoycoColors.error,
        ),
        gapPadding: 0,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: StoycoColors.error,
        ),
        gapPadding: 0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: const Color.fromRGBO(0, 122, 255, 1),
        disabledForegroundColor: Colors.white.withOpacity(0.38),
        disabledBackgroundColor: const Color(0xff6699FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Geomanist',
          fontSize: 18,
          letterSpacing: 0,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    ),
    radioTheme: const RadioThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  );
}
