import 'dart:convert';

class SavedStory {
  String prompt;
  String story;
  String time;

  SavedStory({
    required this.prompt,
    required this.story,
    required this.time,
  });

  factory SavedStory.fromRawJson(String str) => SavedStory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SavedStory.fromJson(Map<String, dynamic> json) => SavedStory(
        prompt: json["prompt"],
        story: json["story"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "prompt": prompt,
        "story": story,
        "time": time,
      };
}
