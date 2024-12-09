import 'package:ai_story_gen/provider/data_provider.dart';
import 'package:flutter/material.dart';

import 'package:ai_story_gen/screens/final_screen.dart';
import 'package:ai_story_gen/services/story_gen_service.dart';
import 'package:provider/provider.dart';

// import 'story_narrate_screen.dart';

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
            builder: (context) => FinalScreen(
                  data: _textEditingController.text,
                )));
    return;
  }

  Future<void> _refreshStroy() async {
    setState(() {
      _isLoading = true;
      _isGenerate = true;
    });
    try {
      data1 = await StoryGenService.generateStory(
        "${_textEditingController.text} refresh it ",
        context.read<DataProvider>().getGenres(),
        context.read<DataProvider>().getThemes(),
        context.read<DataProvider>().getLanguages(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Story Generated")),
        actions: [
          InkWell(
            onTap: () {
              _finalScreen();
            },
            child: const Icon(Icons.queue_music_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          _isEditing
              ? TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  scrollController: _scrollController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Edit Story"),
                )
              : Text(
                  _textEditingController.text,
                  style: const TextStyle(fontSize: 16.0),
                ),
          ElevatedButton(onPressed: _isToggle, child: _isEditing ? const Icon(Icons.next_plan) : const Icon(Icons.edit))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshStroy,
        child: _isLoading ? const CircularProgressIndicator() : const Icon(Icons.refresh),
      ),
    );
  }
}
