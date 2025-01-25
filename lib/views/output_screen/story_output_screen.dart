import 'package:ai_story_gen/provider/data_provider.dart';
import 'package:ai_story_gen/theme/theme_provider.dart';
import 'package:ai_story_gen/views/home/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:ai_story_gen/views/listen_screen/story_listen_screen.dart';
import 'package:ai_story_gen/services/story_gen_service.dart';
import 'package:provider/provider.dart';

class OutputDisplay extends StatefulWidget {
  final String data;
  const OutputDisplay({
    super.key,
    required this.data,
  });

  @override
  State<OutputDisplay> createState() => _OutputDisplayState();
}

class _OutputDisplayState extends State<OutputDisplay> {
  String? data1;
  bool _isLoading = false;
  bool _isGenerate = false;
  bool _isEditing = false;

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = !_isGenerate ? widget.data : data1.toString();
  }

  void _finalScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryListenScreen(
          data: _textEditingController.text,
        ),
      ),
    );
  }

  Future<void> _refreshStroy() async {
    var provider = context.read<DataProvider>();

    setState(() {
      _isLoading = true;
      _isGenerate = true;
    });
    try {
      data1 = await StoryGenService.getStory(
        "${_textEditingController.text} refresh it ",
        provider.getGenres(),
        provider.getThemes(),
        provider.getLanguages(),
      );
      _textEditingController.text = data1!;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to refresh.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _isToggle() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<ThemeProvider>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  ),
                  Center(
                      child: Text(
                    "Story Generated",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  InkWell(
                    onTap: () {
                      _finalScreen();
                    },
                    child: const Icon(Icons.queue_music_outlined),
                  ),
                ],
              ),
            ),
            Divider(),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .7,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                      child: TextField(
                        enabled: _isEditing,
                        controller: _textEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 1,
                        style: TextStyle(
                          color: provider.getThemeValue() ? Colors.white : Colors.black,
                        ),
                        scrollController: _scrollController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: _isEditing ? "Edit Story" : "Story",
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        tooltip: _isEditing ? "Edit" : "Save",
                        onPressed: _isToggle,
                        icon: _isEditing ? const Icon(Icons.next_plan) : const Icon(Icons.edit),
                      ),
                      Text(_isEditing ? "save" : "Edit"),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[50],
        elevation: 12,
        onPressed: _refreshStroy,
        child: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.refresh),
      ),
    );
  }
}
