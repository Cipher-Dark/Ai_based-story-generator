import 'package:flutter/material.dart';

class CustomSmallButton extends StatelessWidget {
  const CustomSmallButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
