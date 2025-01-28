import 'package:ai_story_gen/model/saved_story.dart';
import 'package:ai_story_gen/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  // get current user
  static User get user => auth.currentUser!;
  static late UserModel userData;
  static late SavedStory storyData;

  static createUser(String name) async {
    firebaseFirestore.collection("users").doc(user.uid).set(
      {
        "uid": user.uid,
        "name": user.displayName ?? name,
        "email": user.email ?? "",
        "profileUrl": user.photoURL ?? "null",
      },
    );
  }

  static Future<void> getCurrentUser() async {
    await firebaseFirestore.collection('users').doc(user.uid).get().then(
      (user) {
        userData = UserModel.fromJson(user.data()!);
      },
    );
  }

  static Future<bool> isUserExist() async {
    return (await firebaseFirestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<void> saveOnline(String story, String time, String prompt) async {
    firebaseFirestore.collection("data").doc(user.uid).collection("storys").add(
      {
        "story": story,
        "prompt": prompt,
        "time": time,
      },
    );
  }

  static Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getOnlineStory() {
    return firebaseFirestore.collection("data").doc(user.uid).collection("storys").snapshots().map((snapshot) => snapshot.docs);
  }
}
