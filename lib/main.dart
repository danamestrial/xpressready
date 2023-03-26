import 'package:flutter/material.dart';
// import 'package:rishe/settingscreen.dart';
//
import 'homescreen.dart';
// import "exchangescreen.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // we can omit this (as it is by default anyway)
      routes: {
        '/': (context) => const HomeScreen(),
        // '/exchange': (context) => const ExchangeScreen(),
        // '/setting': (context) => const SettingScreen(),
      },
    );
  }
}