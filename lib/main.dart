import 'package:ai_story_gen/provider/data_provider.dart';
import 'package:ai_story_gen/provider/keep_loign_provider.dart';
import 'package:ai_story_gen/screens/story_input_screen.dart';
import 'package:ai_story_gen/share_preference/save_login.dart';
import 'package:ai_story_gen/screens/login_screen.dart';
import 'package:ai_story_gen/theme/theme_provider.dart';
import 'package:ai_story_gen/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KeepLoignProvider(),
        ),
      ],
      child: StoryGenApp(),
    ),
  );
}

class StoryGenApp extends StatelessWidget {
  StoryGenApp({super.key});
  final prefs = SharedPreferences.getInstance();
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
              return const LoginScreen(); // User is not logged in
            }
          }
        },
      ),
    );
  }
}
