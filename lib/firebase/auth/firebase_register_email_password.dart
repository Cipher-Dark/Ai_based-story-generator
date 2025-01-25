// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:ai_story_gen/utils/apis.dart';
import 'package:ai_story_gen/utils/dialogs.dart';
import 'package:ai_story_gen/views/botom_nav_bar/bottom_nav_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseRegisterEmailPassword {
  registrationWithEmailPass({
    required BuildContext context,
    required String emailEditingController,
    required String passEditingController,
    required String nameEditingController,
  }) async {
    if (passEditingController != "" && emailEditingController != "") {
      try {
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailEditingController)) {
          Dialogs.showSnackBarError(
            context,
            "Invalid email format",
          );

          return;
        }

        if (passEditingController.length < 6) {
          Dialogs.showSnackBarError(context, "Password must be at least 6 characters");

          return;
        }
        Dialogs.showProgressBar(context);

        try {
          await Apis.auth.createUserWithEmailAndPassword(
            email: emailEditingController,
            password: passEditingController,
          );
          if (!(await Apis.isUserExist())) {
            Apis.createUser(nameEditingController);
          }

          Dialogs.showSnackBar(context, "Sign in Successful");
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
            (Route<dynamic> route) => false,
          );
        } catch (e) {
          Navigator.pop(context);

          Dialogs.showSnackBarError(context, "Try again!");
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        log(e.toString());
        if (e.code == "email-already-in-use") {
          Dialogs.showSnackBarError(context, "Email already registered");
        } else {
          Dialogs.showSnackBarError(context, "An error occurred, please try again");
        }
      } catch (e) {
        Navigator.pop(context);

        Dialogs.showSnackBarError(context, "An error occurred, please try again");
      }
    }
  }
}
