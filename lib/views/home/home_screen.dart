// ignore_for_file: use_build_context_synchronously

import 'package:ai_story_gen/provider/data_provider.dart';
import 'package:ai_story_gen/services/story_gen_service.dart';
import 'package:ai_story_gen/utils/apis.dart';
import 'package:ai_story_gen/utils/dialogs.dart';
import 'package:ai_story_gen/views/output_screen/story_output_screen.dart';
import 'package:ai_story_gen/widgets/custom_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Apis.getCurrentUser();
    Apis.getOnlineStory();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hides the keyboard when click outside the keynoard.
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Story Generator',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enter a story prompt:', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _promptController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'E.g., "A brave knight sets out on a quest..."',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        spacing: 15,
                        children: [
                          CustomDropDown(
                              label: 'Genre',
                              items: context.read<DataProvider>().getListOfGenres(),
                              selectedValue: context.read<DataProvider>().getGenres(),
                              onChanged: (value) {
                                context.read<DataProvider>().setGenres(value!);
                              }),
                          CustomDropDown(
                              label: 'Theme',
                              items: context.read<DataProvider>().getListOfThemes(),
                              selectedValue: context.read<DataProvider>().getThemes(),
                              onChanged: (value) {
                                context.read<DataProvider>().setTheme(value!);
                              }),
                          CustomDropDown(
                              label: 'Language',
                              items: context.read<DataProvider>().getListOfLanguages(),
                              selectedValue: context.read<DataProvider>().getLanguages(),
                              onChanged: (value) {
                                context.read<DataProvider>().setLanguage(value!);
                              }),
                        ],
                      ),
                      const SizedBox(height: 120),
                      GestureDetector(
                        onTap: context.watch<DataProvider>().getLoading() ? null : () => generateStory(context, _promptController.text),
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width * .9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.purple.withValues(alpha: .2),
                            border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
                          ),
                          child: Center(
                            child: context.watch<DataProvider>().getLoading()
                                ? Image.asset("assets/icon/loader.gif")
                                : const Text(
                                    'Generate Story',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> generateStory(BuildContext context, String prompt) async {
  var provider = context.read<DataProvider>();
  provider.changeLoading(true);
  if (prompt == '') {
    Dialogs.showSnackBarError(context, 'Enter a prompt');
    provider.changeLoading(false);
    return;
  }
  try {
    String? story = await StoryGenService.getStory(
      prompt,
      provider.getGenres(),
      provider.getThemes(),
      provider.getLanguages(),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutputDisplay(
          data: story.toString(),
          // data: "The Journey Beyond the Horizon follows Arun, a curious young boy from a small village, who sets out on an adventure to find an ancient island hidden in the ocean, seeking its rumored power and treasure. After facing perilous trials and a mysterious figure warning him of the price—his soul—Arun chooses knowledge over power, realizing that true wisdom lies not in what one takes, but in what one gives, ultimately returning to his village with a deeper understanding of life's true treasures.",
        ),
      ),
    );
  } catch (e) {
    Dialogs.showSnackBarError(context, 'Failed to generate story.$e');
  } finally {
    provider.changeLoading(false);
  }
}
