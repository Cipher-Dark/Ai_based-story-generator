import 'dart:developer';

import 'package:ai_story_gen/theme/theme_provider.dart';
import 'package:ai_story_gen/widgets/custom_small_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

class StoryListenScreen extends StatefulWidget {
  final String data;

  StoryListenScreen({
    super.key,
    required this.data,
  });

  @override
  State<StoryListenScreen> createState() => _StoryListenScreenState();
}

class _StoryListenScreenState extends State<StoryListenScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  final Map<String, String> _languageMap = {
    'en-US': 'English',
    'hi-IN': 'Hindi',
    'ur-PK': 'Urdu',
    'ja-JP': 'Japanese',
    'ko-KR': 'Korean',
    'ru-Ru': 'Russian',
  };

  String _selectedLanguage = 'en-US';
  List<String> _languages = [];
  int? _currentWordStart;
  int? _currentWordEnd;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    _flutterTts.setProgressHandler((String text, int start, int end, String? word) {
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });

    List<dynamic> availableLanguages = await _flutterTts.getLanguages;
    _languages = availableLanguages.where((language) => _languageMap.keys.contains(language)).map((language) => language.toString()).toList();
    setState(() {});
  }

  void _speak(String text) async {
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.speak(text);
    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() async {
    await _flutterTts.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _save(String text) async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String fileName = "Story_File_$timestamp.mp3";

      await _flutterTts.setLanguage(_selectedLanguage);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.synthesizeToFile(text, fileName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved $fileName")),
      );
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save file: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Listen")),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          _buildDropdown(
            label: 'Select Language',
            items: _languages,
            selectedValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * .95,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            child: SingleChildScrollView(
              child: !_isPlaying
                  ? Text(
                      widget.data,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.watch<ThemeProvider>().getThemeValue() ? Colors.white : Colors.black,
                      ),
                    )
                  : RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          color: context.watch<ThemeProvider>().getThemeValue() ? Colors.white : Colors.black,
                        ),
                        children: [
                          if (_currentWordStart != null)
                            TextSpan(
                              text: widget.data.substring(0, _currentWordStart!),
                            ),
                          if (_currentWordStart != null && _currentWordEnd != null)
                            TextSpan(
                              text: widget.data.substring(
                                _currentWordStart!,
                                _currentWordEnd!,
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.purple,
                              ),
                            ),
                          if (_currentWordEnd != null)
                            TextSpan(
                              text: widget.data.substring(_currentWordEnd!),
                            ),
                        ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomSmallButton(
                  icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: _isPlaying ? Colors.blue : Colors.green,
                  label: _isPlaying ? "Pause" : "Play",
                  onPressed: () {
                    if (_isPlaying) {
                      _pause();
                    } else {
                      _speak(widget.data);
                    }
                  }),
              CustomSmallButton(icon: Icons.stop, color: Colors.red, label: "Stop", onPressed: _stop),
              CustomSmallButton(
                icon: Icons.download,
                color: Colors.grey,
                label: "Download Audio",
                onPressed: () {
                  _save(widget.data);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({required String label, required List<String> items, required String selectedValue, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            isExpanded: true,
            value: selectedValue,
            onChanged: onChanged,
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(_languageMap[item]!),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
