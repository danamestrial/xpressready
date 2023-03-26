import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpressready/screen/home_screen.dart';
import 'package:xpressready/screen/login_register_switch.dart';
import 'package:xpressready/screen/setting_screen.dart';
import 'package:xpressready/screen/test_logged_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // is User Logged in
          if (snapshot.hasData) {
            return HomeScreen();
          }
          else {
            return const LoginRegisterScreen();
          }
        },
      ),
    );
  }
}