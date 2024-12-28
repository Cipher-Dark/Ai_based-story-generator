import 'package:ai_story_gen/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: size.width * .40),
                  child: Text(
                    "Setting",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(
              right: 30,
              left: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Consumer<ThemeProvider>(
                  builder: (ctx, provider, __) {
                    return Switch(
                      value: provider.getThemeValue(),
                      onChanged: (value) {
                        provider.toggleTheme();
                      },
                    );
                  },
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
