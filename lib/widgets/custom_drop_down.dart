import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}
