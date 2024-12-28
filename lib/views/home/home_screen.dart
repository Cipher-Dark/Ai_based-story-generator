import 'package:ai_story_gen/provider/data_provider.dart';
import 'package:ai_story_gen/setting/setting_page.dart';
import 'package:ai_story_gen/theme/theme_provider.dart';
import 'package:ai_story_gen/views/output_screen/story_output_screen.dart';
import 'package:ai_story_gen/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/story_gen_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  Future<void> _generateStory() async {
    context.read<DataProvider>().changeLoading(true);
    if (_promptController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            showCloseIcon: true,
            content: Center(
              child: Text('Enter a prompt'),
            )),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingPage(),
                ),
              );
            },
            icon: Icon(Icons.settings),
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
                    child: CustomDropDown(
                        label: 'Genre',
                        items: context.read<DataProvider>().getListOfGenres(),
                        selectedValue: context.read<DataProvider>().getGenres(),
                        onChanged: (value) {
                          context.read<DataProvider>().setGenres(value!);
                        })),
                const SizedBox(width: 16),
                Expanded(
                    child: CustomDropDown(
                        label: 'Theme',
                        items: context.read<DataProvider>().getListOfThemes(),
                        selectedValue: context.read<DataProvider>().getThemes(),
                        onChanged: (value) {
                          context.read<DataProvider>().setTheme(value!);
                        })),
                Expanded(
                    child: CustomDropDown(
                        label: 'Language',
                        items: context.read<DataProvider>().getListOfLanguages(),
                        selectedValue: context.read<DataProvider>().getLanguages(),
                        onChanged: (value) {
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
}
