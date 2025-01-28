import 'package:ai_story_gen/views/setting/setting_page.dart';
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
              color: _currentIndex == 1 ? Colors.purple : null,
            ),
            label: "Profile",
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
