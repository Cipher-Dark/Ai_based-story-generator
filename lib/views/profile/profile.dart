import 'package:ai_story_gen/model/saved_story.dart';
import 'package:ai_story_gen/utils/apis.dart';
import 'package:ai_story_gen/views/listen_screen/story_listen_screen.dart';
import 'package:ai_story_gen/views/setting/setting_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late SavedStory savedStory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 10,
            children: [
              profileTile(),
              Divider(height: 20),
              Text(
                "Saved stories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              storystream(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>> storystream() {
    return StreamBuilder(
      stream: Apis.getOnlineStory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No Online stories found"));
        }

        var stories = snapshot.data!;

        return Expanded(
          child: ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              savedStory = SavedStory.fromJson(stories[index].data());
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryListenScreen(
                        data: stories[index]['story'],
                        isonlin: true,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to remove this story?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Apis.removeOnlinStory(stories[index].id);
                              Navigator.pop(context);
                            },
                            child: Text('Remove'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: storyTile(index),
              );
            },
          ),
        );
      },
    );
  }

  Column storyTile(int index) {
    return Column(
      children: [
        ListTile(
          leading: Text(
            "${index + 1}",
            style: TextStyle(fontSize: 18),
          ),
          title: Text(savedStory.prompt),
          subtitle: Text(
            savedStory.story,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(),
      ],
    );
  }

  ListTile profileTile() {
    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          imageUrl: Apis.userData.profileUrl,
          errorWidget: (context, url, error) => Image.asset("assets/profile.png"),
        ),
      ),
      title: Text(
        Apis.userData.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        Apis.userData.email,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
      trailing: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SettingPage()));
        },
        child: Icon(
          Icons.settings_outlined,
          size: 30,
        ),
      ),
    );
  }
}
