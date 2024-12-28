import 'dart:developer';

import 'package:ai_story_gen/firebase/multi_auth/multi_auth_link.dart';
import 'package:ai_story_gen/screens/story_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseEmailPassword {
  signInWithPassword(context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final credential = EmailAuthProvider.credential(email: email, password: password);
      MultiAuthLink().multiAuth(credential);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          elevation: 12.3,
          content: Text(
            "Login Successful",
            style: TextStyle(fontSize: 20),
          )));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StoryInputPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.black54,
            content: Center(
              child: Text(
                "User not found",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.black54,
            content: Center(
              child: Text(
                "Wrong Password",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.black54,
            content: Center(
              child: Text(
                "Email is not valid",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        );
      }
    }
  }
}
