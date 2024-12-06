import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  String _selectedGenre = 'Fantasy'; // Default genre
  String _selectedTheme = 'Adventure'; // Default theme
  String _selectLanguage = 'Hindi'; // Default language
  bool _isLoading = false;

  final List<String> _genres = [
    'Mystery',
    'Sci-Fi',
    'Horror',
    'Fantasy',
    'Romance'
  ];

  final List<String> _themes = [
    'Adventure',
    'Drama',
    'Humor',
    'Suspense',
    'Tragedy'
  ];
  final List<String> _landuages = [
    'Hindi',
    'English',
  ];

  String getGenres() => _selectedGenre;
  String getLanguages() => _selectLanguage;
  String getThemes() => _selectedTheme;
  bool getLoading() => _isLoading;

  List<String> getListOfGenres() => _genres;
  List<String> getListOfLanguages() => _landuages;
  List<String> getListOfThemes() => _themes;

  void setGenres(String genres) {
    _selectedGenre = genres;
    notifyListeners();
  }

  void setLanguage(String language) {
    _selectLanguage = language;
    notifyListeners();
  }

  void setTheme(String theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void changeLoading(bool load) {
    _isLoading = load;
    notifyListeners();
  }
}
