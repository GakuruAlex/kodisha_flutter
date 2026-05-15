import 'package:flutter/material.dart';

class DynamicFormField {
  final String fieldLabel;
  final TextInputType? textInputType;
  final IconData fieldIcon;
  final List<String>? options;
  final List<DynamicFormField>? subFields;
  const DynamicFormField({
    required this.fieldLabel,
    this.textInputType,
    required this.fieldIcon,
    this.options, 
    this.subFields
  });
}
