import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GAuthService {

  // Google Sign in
  signInWithGoogle(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      // Pop up interaction sign in process with google
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // obtain auth
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // signs in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print("Boom");
    } finally {
      Navigator.pop(context);
    }

  }

  static signInAnonymous(context) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    } finally {
      Navigator.pop(context);
    }
  }

  static signOut() async {
    FirebaseAuth.instance.signOut();
  }
}