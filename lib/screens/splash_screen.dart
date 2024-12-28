import 'package:ai_story_gen/screens/login_screen.dart';
import 'package:ai_story_gen/screens/story_input_screen.dart';
import 'package:ai_story_gen/share_preference/save_login.dart';
import 'package:ai_story_gen/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().getThemeValue() ? ThemeData.dark() : ThemeData.light(),
      home: FutureBuilder<bool>(
        future: SaveLogin().getLoginPref(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading state
          } else {
            if (snapshot.data == true) {
              return const StoryInputPage(); // User is logged in
            } else {
              return LoginScreen(); // User is not logged in
            }
          }
        },
      ),
    );
  }
}
