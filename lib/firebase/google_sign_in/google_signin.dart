import 'package:ai_story_gen/views/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignin {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Attempt to sign in the user with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          elevation: 12.3,
          content: Text(
            "Login Successful",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $error')),
      );
    }
  }
}
