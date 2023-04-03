import 'package:flutter/material.dart';
import 'package:xpressready/screen/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xpressready/screen/forgot_password_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // we can omit this (as it is by default anyway)
      routes: {
        '/': (context) => const AuthScreen(),
        '/test': (context) => ForgotPasswordScreen(),
      },
    );
  }
}