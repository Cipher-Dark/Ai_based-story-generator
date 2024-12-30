import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Stack(
                  fit: StackFit.passthrough,
                  children: [
                    CircleAvatar(
                      radius: 33,
                      backgroundColor: Colors.grey,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!) : AssetImage('assets/profile.png') as ImageProvider,
                    ),
                  ],
                )
              ],
            ),
            Divider(),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: "${FirebaseAuth.instance.currentUser?.displayName}\n",
                    style: const TextStyle(fontSize: 20),
                    children: const [
                      TextSpan(
                        text: "Show profile",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
