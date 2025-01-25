import 'package:flutter/material.dart';

class SignInMethods extends StatelessWidget {
  final String text;
  final String icon;
  final double widthsize;

  const SignInMethods({
    super.key,
    required this.text,
    required this.icon,
    required this.widthsize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthsize,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0XFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Image.asset(
            icon,
          ),
          Text(
            text,
            style: TextStyle(
              color: Color(0XFF475569),
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}
