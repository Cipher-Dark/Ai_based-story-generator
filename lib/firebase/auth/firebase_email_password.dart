import 'package:ai_story_gen/firebase/multi_auth/multi_auth_link.dart';
import 'package:ai_story_gen/utils/dialogs.dart';
import 'package:ai_story_gen/views/botom_nav_bar/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseEmailPassword {
  signInWithPassword(context, String email, String password) async {
    try {
      Dialogs.showProgressBar(context);
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final credential = EmailAuthProvider.credential(email: email, password: password);
      MultiAuthLink().multiAuth(credential);
      Navigator.pop(context);
      Dialogs.showSnackBar(context, "Login Successful");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavBar(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        Dialogs.showSnackBarError(
          context,
          "User not found",
        );
      } else if (e.code == 'invalid-credential') {
        Dialogs.showSnackBarError(
          context,
          "invalid-credential",
        );
      }
    }
  }
}
