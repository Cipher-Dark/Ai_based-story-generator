import 'dart:developer';
import 'package:ai_story_gen/utils/apis.dart';
import 'package:ai_story_gen/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleSignin {
  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Attempt to sign in the user with Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      Dialogs.showProgressBar(context);

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;
        log(user!.displayName.toString());
        Apis.createUser(user.displayName.toString());
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: $error')),
        );
      }
    }
  }
}
