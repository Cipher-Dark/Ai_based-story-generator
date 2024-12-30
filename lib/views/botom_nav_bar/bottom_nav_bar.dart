import 'package:ai_story_gen/setting/setting_page.dart';
import 'package:ai_story_gen/views/home/home_screen.dart';
import 'package:ai_story_gen/views/profile/profile.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _listWidget = [
    HomeScreen(),
    Profile(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/user.png",
              color: _currentIndex == 1 ? Colors.blue[300] : Colors.grey[700],
            ),
            label: "Profile",
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Setting",
            backgroundColor: Colors.pink,
          )
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[300],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
