import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class StoryGenService {
  // Method to call the API and generate a story
  static Future<String?> generateStory(
      // final keyy = dotenv.env['GEMINI_API_KEY'];
      // log(keyy.toString());
      String prompt,
      String genre,
      String theme,
      String language) async {
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
      Content.text(
          "This is my prompt'$prompt' (first correct the spellings if exist in prompt) and set  genre '$genre', and theme '$theme' language '$language' of  this story(Story must be long, and remove '#' from the output).")
    ]);
    return response.text;
  }
}
