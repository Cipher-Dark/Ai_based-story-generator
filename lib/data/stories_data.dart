import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StoriesDataProvider extends ChangeNotifier {
  List<Map<String, String>> _stories = [
    {
      'title': 'The Adventure of the Speckled Band',
      'story': 'A thrilling mystery...',
      'date': '2023-10-01',
    },
    {
      'title': 'The Tell-Tale Heart',
      'story': 'A chilling tale...',
      'date': '2023-10-02',
    },
    {
      'title': 'The Metamorphosis',
      'story': 'A surreal transformation...',
      'date': '2023-10-03',
    },
  ];

  List<Map<String, String>> get stories => _stories;

  StoriesDataProvider() {
    _loadStoriesFromPrefs();
  }
  int get storyCount => _stories.length;
  void _loadStoriesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storiesString = prefs.getString('stories');
    if (storiesString != null) {
      _stories = List<Map<String, String>>.from(json.decode(storiesString));
      notifyListeners();
    }
  }

  void addStory(int id, String title, String story, String date) {
    _stories.add({
      'id': id.toString(),
      'title': title,
      'story': story,
      'date': date
    });
    _saveStoriesToPrefs();
    notifyListeners();
  }

  void _saveStoriesToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stories', json.encode(_stories));
  }

  void removeStory(int index) {
    _stories.removeAt(index);
    _saveStoriesToPrefs();
    notifyListeners();
  }

  void updateStory(int index, Map<String, String> story) {
    _stories[index] = story;
    _saveStoriesToPrefs();
    notifyListeners();
  }
}
