import 'package:flutter/material.dart';

class UtilityFormConfig {
  final UniqueKey id; // Unique identifier for this specific form block
  String? selectedType; // Track if they chose "Water", "Electricity", etc.
  final Map<String, TextEditingController> controllers;

  UtilityFormConfig({
    required this.id,
    this.selectedType,
    required this.controllers,
  });
}