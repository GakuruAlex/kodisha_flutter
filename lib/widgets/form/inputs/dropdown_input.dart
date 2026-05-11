import 'package:flutter/material.dart';

class DropdownInput extends StatelessWidget {
  final String label;
  final List<String> options;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const DropdownInput({
    super.key,
    required this.label,
    required this.options,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: (controller != null && options.contains(controller!.text)) 
          ? controller!.text 
          : null,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down_circle_outlined, size: 20),
      dropdownColor: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        label: Text(label),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      items: options.map((value) => DropdownMenuItem(
        value: value, 
        child: Text(value)
      )).toList(),
      onChanged: (val) => controller?.text = val ?? "",
      validator: validator,
    );
  }
}