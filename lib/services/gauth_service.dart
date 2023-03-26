import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GAuthService {

  // Google Sign in
  signInWithGoogle() async {
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
  }
}