import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpressready/components/text_field.dart';
import 'package:xpressready/components/sign_up_button.dart';
import 'package:xpressready/components/square_tile_icon.dart';
import 'package:xpressready/services/gauth_service.dart';

// This screen is heavily inspired by Mitch Koko
// https://github.com/mitchkoko/ModernLoginUI

class RegisterScreen extends StatefulWidget {
  final Function() onTap;

  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  String alert = "";

  // set state to alert message
  void setAlert(String msg) {
    setState(() {
      alert = msg;
    });
  }

  // sign user in method
  void signUserIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          FirebaseFirestore.instance.collection('users')
              .doc(user.uid).set({
            "full_name" : nameController.text,
            "email" : emailController.text,
            "phone_number" : phoneController.text,
            "license_plate" : "",
            "vehicle_brand" : "",
            "add_info" : ""
          });
        }

      } else {
        // Show error that password don't match
        setAlert('Password did not match');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setAlert('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setAlert('The account already exists for that email.');
      }
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFBF2CF),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome! Create an account',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    alert,
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // full name textfield
                  MyTextField(
                    controller: nameController,
                    hintText: 'Full Name',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // username textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // phone number textfield
                  MyTextField(
                    controller: phoneController,
                    hintText: 'Phone Number',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  MyButton(
                    text: "Sign Up",
                    onTap: signUserIn,
                  ),

                  const SizedBox(height: 40),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // google + apple sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(
                        onTap: () => GAuthService().signInWithGoogle(context),
                        imagePath: 'lib/images/google.png',
                      ),

                      const SizedBox(width: 30,),

                      SquareTile(
                        onTap: () => GAuthService.signInAnonymous(context),
                        imagePath: 'lib/images/icognito.webp',
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}