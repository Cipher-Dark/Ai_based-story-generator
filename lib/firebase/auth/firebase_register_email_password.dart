import 'dart:developer';

import 'package:ai_story_gen/views/botom_nav_bar/bottom_nav_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseRegisterEmailPassword {
  registrationWithEmailPass(
    context,
    String emailEditingController,
    String passEditingController,
  ) async {
    if (passEditingController != "" && emailEditingController != "") {
      try {
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailEditingController)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Invalid email format",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
          return;
        }

        if (passEditingController.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password must be at least 6 characters",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
          return;
        }

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailEditingController,
          password: passEditingController,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            elevation: 12.3,
            content: Text(
              "Sign in Successful",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );

        try {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ),
            (Route<dynamic> route) => false,
          );
        } catch (e) {
          log('Navigation error: $e');
        }
      } on FirebaseAuthException catch (e) {
        log(e.toString());
        if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Email already in use",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "An error occurred, please try again",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "An error occurred, please try again",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    }
  }
}
