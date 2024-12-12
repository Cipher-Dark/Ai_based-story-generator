import 'package:ai_story_gen/provider/data_provider.dart';
import 'package:ai_story_gen/provider/keep_loign_provider.dart';
import 'package:ai_story_gen/theme/theme_provider.dart';
import 'package:ai_story_gen/screens/story_output_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/story_gen_service.dart';

class StoryInputPage extends StatefulWidget {
  const StoryInputPage({super.key});

  @override
  _StoryInputPageState createState() => _StoryInputPageState();
}

class _StoryInputPageState extends State<StoryInputPage> {
  final TextEditingController _promptController = TextEditingController();
  Future<void> _generateStory() async {
    context.read<DataProvider>().changeLoading(true);
    if (_promptController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('Enter a prompt'))),
      );
      context.read<DataProvider>().changeLoading(false);
      return;
    }
    try {
      String? story = await StoryGenService.generateStory(
        _promptController.text,
        context.read<DataProvider>().getGenres(),
        context.read<DataProvider>().getThemes(),
        context.read<DataProvider>().getLanguages(),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutputDisplay(
            data: story.toString(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate story.')),
      );
    } finally {
      context.read<DataProvider>().changeLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Generator'),
        actions: [
          IconButton(
            icon: context.watch<ThemeProvider>().getThemeValue() ? const Icon(Icons.wb_sunny) : const Icon(Icons.nights_stay),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
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
                    child: _buildDropdown('Genre', context.read<DataProvider>().getListOfGenres(), context.read<DataProvider>().getGenres(), (value) {
                  context.read<DataProvider>().setGenres(value!);
                })),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildDropdown('Theme', context.read<DataProvider>().getListOfThemes(), context.read<DataProvider>().getThemes(), (value) {
                  context.read<DataProvider>().setTheme(value!);
                })),
                Expanded(
                    child: _buildDropdown('Language', context.read<DataProvider>().getListOfLanguages(), context.read<DataProvider>().getLanguages(), (value) {
                  context.read<DataProvider>().setLanguage(value!);
                })),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: context.watch<DataProvider>().getLoading() ? null : _generateStory,
                child: context.watch<DataProvider>().getLoading() ? const CircularProgressIndicator() : const Text('Generate Story'),
              ),
            ),
          ],
        ),
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
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
