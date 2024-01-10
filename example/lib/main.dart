import 'package:example/form/date_picker/date_picker.dart';
import 'package:example/themes.dart';
import 'package:flutter/material.dart';

import 'form/phone_number/phone_number.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.stoycoTheme,
      home: const Scaffold(
        body: SafeArea(
            minimum: EdgeInsets.all(30),
            child: Center(child: DatePickerView())),
      ),
    );
  }
}
