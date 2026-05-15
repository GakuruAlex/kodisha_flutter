import 'package:flutter/material.dart';

class DropdownInput extends StatelessWidget {
  final String label;
  final List<String> options;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String?>? onChanged; // Added this line

  const DropdownInput({
    super.key,
    required this.label,
    required this.options,
    this.controller,
    this.validator,
    this.onChanged, // Added this line
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      // Changed initialValue to value to handle state changes accurately
      initialValue: (controller != null && options.contains(controller!.text))
          ? controller!.text
          : null,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down_circle_outlined, size: 20),
      dropdownColor: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      items: options
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          )
          .toList(),
      onChanged: (val) {
        // 1. Keep your original logic to update the controller
        if (controller != null) {
          controller!.text = val ?? "";
        }
        // 2. Notify the FormFieldWidget and DynamicForm that a selection occurred
        if (onChanged != null) {
          onChanged!(val);
        }
      },
      validator: validator,
    );
  }
}
