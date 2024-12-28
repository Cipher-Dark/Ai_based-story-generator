import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final Icon icon;
  final String hintText;
  final String labelText;
  final bool obscureText;
  const CustomTextFiled({super.key, required this.passwordController, required, required this.icon, required this.hintText, required this.labelText, required this.obscureText});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // For password masking
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        hintStyle: const TextStyle(color: Colors.black54),
        prefixIcon: icon,
      ),
    );
  }
}
