import 'package:ai_story_gen/provider/data_provider.dart';
import 'package:ai_story_gen/provider/toggle_provider.dart';
import 'package:ai_story_gen/firebase/firebase_options.dart';
import 'package:ai_story_gen/screens/story_input_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

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
          create: (context) => ToggelProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DataProvider(),
        )
      ],
      child: const StoryGenApp(),
    ),
  );
}

class StoryGenApp extends StatefulWidget {
  const StoryGenApp({super.key});

  @override
  _StoryGenAppState createState() => _StoryGenAppState();
}

class _StoryGenAppState extends State<StoryGenApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ToggelProvider>().getThemeValue() ? ThemeData.dark() : ThemeData.light(),
      home: StoryInputPage(),
    );
  }
}
