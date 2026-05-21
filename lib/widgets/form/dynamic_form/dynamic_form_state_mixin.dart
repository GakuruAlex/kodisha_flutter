import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dynamic_form.dart';

mixin DynamicFormStateMixin on State<DynamicForm> {
  XFile? image;
  List<XFile>? images;
  final Map<String, String?> selectedDropdownValues = {};

  void populateEditValues() {
    if (!widget.isNested && widget.formType.toLowerCase().contains("edit") && widget.model != null) {
      final values = widget.model!.toFormValues();
      final currentPrefix = widget.parentKeyPrefix.isEmpty
          ? widget.formType.replaceAll(" ", "").toLowerCase()
          : widget.parentKeyPrefix;

      widget.controllers.forEach((key, controller) {
        if (key.startsWith("${currentPrefix}_")) {
          final modelKey = key.replaceFirst("${currentPrefix}_", "");
          if (values.containsKey(modelKey) && values[modelKey] != null) {
            controller.text = values[modelKey].toString();
          }
        } else if (values.containsKey(key) && values[key] != null) {
          controller.text = values[key].toString();
        }
      });
    }
  }

  void syncControllersToDropdownState() {
    final currentPrefix = widget.parentKeyPrefix.isEmpty
        ? widget.formType.replaceAll(" ", "").toLowerCase()
        : widget.parentKeyPrefix;

    for (var field in widget.fields) {
      if (field.options != null && field.options!.isNotEmpty) {
        final sanitizedLabel = field.fieldLabel.replaceAll(" ", "").toLowerCase();
        final key = "${currentPrefix}_$sanitizedLabel";

        if (widget.controllers.containsKey(key) && widget.controllers[key]!.text.isNotEmpty) {
          selectedDropdownValues[field.fieldLabel] = widget.controllers[key]!.text;
        }
      }
    }
  }

  void updateImageState(XFile? file, List<XFile>? files) {
    setState(() {
      image = file;
      images = files;
    });
  }

  void updateDropdownState(String fieldLabel, String key, String? newValue) {
    setState(() {
      selectedDropdownValues[fieldLabel] = newValue;
      widget.controllers[key]?.text = newValue ?? "";
    });
  }
}