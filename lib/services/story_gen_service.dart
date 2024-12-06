import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class StoryGenService {
  static Future<String?> generateStory(String prompt, String genre, String theme, String language) async {
    log("language" + language);
    log("promt" + prompt);
    log("gener" + genre);
    log("thetme" + theme);
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: dotenv.env["GEMINI_API_KEY"]!,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8000,
        responseMimeType: 'text/plain',
      ),
    );
    final response = await model.generateContent([
      Content.text("generate only long story using this prompt '$prompt', set  genre to '$genre', theme to  '$theme', and give story in '$language' (don't involve any other thing except the story).")
    ]);
    return response.text;
  }
}
