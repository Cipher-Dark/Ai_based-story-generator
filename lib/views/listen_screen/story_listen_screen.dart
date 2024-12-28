import 'package:ai_story_gen/widgets/custom_small_buttom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class StoryListenScreen extends StatefulWidget {
  final String data;

  const StoryListenScreen({
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
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = "Story_File_$timestamp.mp4";
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.synthesizeToFile(text, fileName);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: AlertDialog(
        title: Text("Saved"),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Listen")),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildDropdown(
            'Select Language',
            _languages,
            _selectedLanguage,
            (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
          const SizedBox(height: 16),
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
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white70),
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
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
                          style: const TextStyle(
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
          ),
          CustomSmallButton(
              icon: Icons.save,
              color: Colors.grey,
              label: "Save",
              onPressed: () {
                _save(widget.data);
              }),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButton<String>(
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
