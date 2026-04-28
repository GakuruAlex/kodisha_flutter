import 'package:flutter/material.dart';

class DynamicFormField {
  final String fieldLabel;
  final TextInputType? textInputType;
  final IconData fieldIcon;
  const DynamicFormField({
    required this.fieldLabel,
    this.textInputType,
    required this.fieldIcon,
  });
}
