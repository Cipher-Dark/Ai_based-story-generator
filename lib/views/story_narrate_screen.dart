import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FinalScreen extends StatefulWidget {
  final String data;
  const FinalScreen({
    super.key,
    required this.data,
  });

  @override
  State<FinalScreen> createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  final Map<String, String> _languageMap = {
    'en-US': 'English',
    'hi-IN': 'Hindi',
    'ur-PK': 'Urdu',
    'ja-JP': 'Japanese',
    'ko-KR': 'Korean',
    'ru-Ru': 'Russian'
  };
  String _selectLanguage = 'en-US';

  List<String> _language = [];
  int? _currentWordStart, _currendWordEnd;
  bool _isPlay = true;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    _flutterTts.setProgressHandler((text, start, end, word) {
      _currentWordStart = start;
      _currendWordEnd = end;
    });

    List<dynamic> availableLanguages = await _flutterTts.getLanguages;
    _language = availableLanguages.where((language) => _languageMap.keys.contains(language)).map((language) => language as String).toList();
    setState(() {});
  }

  void _speak(String data) async {
    await _flutterTts.setLanguage(_selectLanguage);
    await _flutterTts.speak(data);
    isPlay();
  }

  void isPlay() {
    setState(() {
      _isPlay = !_isPlay;
    });
  }

  void _save(String data) async {
    await _flutterTts.setLanguage(_selectLanguage);
    String timeSpamp = DateTime.now().millisecondsSinceEpoch.toString();
    await _flutterTts.synthesizeToFile(data, "Story_File_$timeSpamp.mp4");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File Downloaded")));
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isPlay = true;
    });
  }

  Future<void> _pasue() async {
    _flutterTts.pause();
    isPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Listen")),
      ),
      body: Column(
        children: [
          const SizedBox(width: 16),
          _buildDropdown(
            'Select Language',
            _language,
            _selectLanguage,
            (value) {
              setState(() {
                _selectLanguage = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Center(
              child: Column(children: [
                IconButton(
                  onPressed: () {
                    _isPlay ? _speak(widget.data) : _pasue();
                  },
                  icon: _isPlay
                      ? const Icon(
                          Icons.play_arrow,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.pause,
                          color: Colors.blue,
                        ),
                ),
                Text(
                  _isPlay ? "Play" : "pause",
                  style: _isPlay ? const TextStyle(color: Colors.green) : const TextStyle(color: Colors.blue),
                ),
              ]),
            ),
            Center(
              child: Column(children: [
                IconButton(
                  onPressed: () {
                    _stop();
                  },
                  icon: const Icon(
                    Icons.stop,
                    color: Colors.red,
                  ),
                ),
                const Text(
                  "Stop",
                  style: TextStyle(color: Colors.red),
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 30),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white70),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.data.substring(0, _currentWordStart),
                        ),
                        if (_currentWordStart != null)
                          TextSpan(
                            text: widget.data.substring(_currentWordStart!, _currendWordEnd),
                            style: const TextStyle(color: Colors.white, backgroundColor: Colors.purple),
                          ),
                        if (_currendWordEnd != null)
                          TextSpan(
                            text: widget.data.substring(_currendWordEnd!),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(children: [
            IconButton(
              onPressed: () {
                _save(widget.data);
              },
              icon: const Icon(Icons.save),
              color: Colors.grey,
            ),
            const Text(
              "Save",
              style: TextStyle(color: Colors.grey),
            )
          ])
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return Column(
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
    );
  }
}
