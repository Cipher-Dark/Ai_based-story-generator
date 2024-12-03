import 'package:ai_story_gen/screens/output_screen.dart';
import 'package:flutter/material.dart';
import '../services/story_gen_service.dart'; // Import the API service

class StoryInputPage extends StatefulWidget {
  final VoidCallback toggleTheme; // Callback to toggle theme
  final bool isDarkMode; // Current theme mode

  const StoryInputPage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _StoryInputPageState createState() => _StoryInputPageState();
}

class _StoryInputPageState extends State<StoryInputPage> {
  final TextEditingController _promptController = TextEditingController();
  String selectedGenre = 'Fantasy'; // Default genre
  String selectedTheme = 'Adventure'; // Default theme
  String selectLanguage = 'Hindi'; // Default language
  bool _isLoading = false;

  final List<String> genres = [
    'Mystery',
    'Sci-Fi',
    'Horror',
    'Fantasy',
    'Romance'
  ];
  final List<String> themes = [
    'Adventure',
    'Drama',
    'Humor',
    'Suspense',
    'Tragedy'
  ];
  final List<String> landuages = [
    'Hindi',
    'English',
  ];
  // Method to generate a story by calling the API (uses service)
  Future<void> _generateStory() async {
    setState(() {
      _isLoading = true;
    });
    if (_promptController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('Enter a prompt'))),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      String? story = await StoryGenService.generateStory(
        _promptController.text,
        selectedGenre,
        selectedTheme,
        selectLanguage,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutputDisplay(
            data: story.toString(),
            selectedGenre: selectedGenre.toString(),
            selectedTheme: selectedTheme.toString(),
            selectedlanguage: selectLanguage.toString(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate story.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Generator'),
        actions: [
          IconButton(
            icon: widget.isDarkMode
                ? const Icon(Icons.wb_sunny)
                : const Icon(Icons.nights_stay),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter a story prompt:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'E.g., "A brave knight sets out on a quest..."',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child:
                        _buildDropdown('Genre', genres, selectedGenre, (value) {
                  setState(() {
                    selectedGenre = value!;
                  });
                })),
                const SizedBox(width: 16),
                Expanded(
                    child:
                        _buildDropdown('Theme', themes, selectedTheme, (value) {
                  setState(() {
                    selectedTheme = value!;
                  });
                })),
                Expanded(
                    child: _buildDropdown('Language', landuages, selectLanguage,
                        (value) {
                  setState(() {
                    selectLanguage = value!;
                  });
                })),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateStory,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Generate Story'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue,
      ValueChanged<String?> onChanged) {
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
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
