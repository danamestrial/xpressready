import 'package:flutter/material.dart';
import 'package:xpressready/screen/login_screen.dart';
import 'package:xpressready/screen/register_screen.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {

  bool isLoginPage = true;

  void toggle() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoginPage) {
      return LoginScreen(onTap: toggle);
    } else
      return RegisterScreen(onTap: toggle);
  }
}