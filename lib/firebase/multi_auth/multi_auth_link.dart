import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class MultiAuthLink {
  multiAuth(AuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
      log(userCredential.toString());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          log("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          log("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          log("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          log("Unknown error.");
      }
    }
  }
}
