import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // get current user
  static User get user => auth.currentUser!;

  static createUser(String name) async {
    var data = firebaseFirestore.collection("users").doc(user.uid).set(
      {
        "uid": user.uid,
        "name": user.displayName ?? name,
        "email": user.email ?? "",
        "profileUrl": user.photoURL ?? "",
      },
    );
    log(data.toString());
  }

  static Future<bool> isUserExist() async {
    return (await firebaseFirestore.collection('users').doc(user.uid).get()).exists;
  }
}
