import 'package:ai_story_gen/utils/apis.dart';
import 'package:ai_story_gen/utils/dialogs.dart';
import 'package:ai_story_gen/views/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignOut {
  static Future<void> signOut(BuildContext context) async {
    try {
      Dialogs.showProgressBar(context);
      await Apis.auth.signOut().then((value) async {
        await GoogleSignIn().signOut().then((value) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
        });
      });
      // ignore: use_build_context_synchronously
      Dialogs.showSnackBar(context, "Sign out success");
    } catch (e) {
      // ignore: use_build_context_synchronously
      Dialogs.showSnackBar(context, "Sign out falil! try after some time.");
    }
  }
}
