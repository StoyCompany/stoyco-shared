import 'package:example/form/password/password.dart';
import 'package:example/themes.dart';
import 'package:flutter/material.dart';

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
            minimum: EdgeInsets.all(30), child: Center(child: Password())),
      ),
    );
  }
}
