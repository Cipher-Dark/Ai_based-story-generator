import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.labelStyle = const TextStyle(fontSize: 16),
    this.itemStyle = const TextStyle(fontSize: 14),
    this.dropdownDecoration = const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey, width: 1),
      ),
    ),
    this.dropdownIcon = Icons.arrow_drop_down,
    this.errorText,
  });

  final String label;
  final List<String> items;
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  final TextStyle labelStyle;
  final TextStyle itemStyle;
  final BoxDecoration dropdownDecoration;
  final IconData dropdownIcon;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with custom style
        Text(
          label,
          style: labelStyle,
        ),
        const SizedBox(height: 8),

        // Dropdown button with additional decoration and icon customization
        Container(
          decoration: dropdownDecoration,
          child: DropdownButton<String>(
            alignment: AlignmentDirectional.centerStart,
            isExpanded: true,
            autofocus: true,
            elevation: 10,
            enableFeedback: true,
            value: selectedValue,
            onChanged: onChanged,
            icon: Icon(dropdownIcon),
            underline: const SizedBox(),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: itemStyle,
                ),
              );
            }).toList(),
          ),
        ),
        // If there's an error, display the error text
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
