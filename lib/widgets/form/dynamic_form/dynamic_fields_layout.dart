import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamci_field_item.dart';
import 'dynamic_form.dart';

class DynamicFieldsLayout extends StatelessWidget {
  const DynamicFieldsLayout({
    super.key,
    required this.fields,
    required this.controllers,
    required this.formType,
    required this.constraints,
    required this.parentKeyPrefix,
    required this.isNested,
    required this.buttonIcon,
    required this.selectedDropdownValues,
    required this.onImagePicked,
    required this.onDropdownChanged,
    this.model,
  });

  final List<DynamicFormField> fields;
  final Map<String, TextEditingController> controllers;
  final String formType;
  final Map<String, double> constraints;
  final String parentKeyPrefix;
  final bool isNested;
  final IconData buttonIcon;
  final FormModel? model;
  final Map<String, String?> selectedDropdownValues;
  final Function(XFile?, List<XFile>?) onImagePicked;
  final Function(String fieldLabel, String key, String? newValue)
  onDropdownChanged;

  String _generateKey(String prefix, String label) {
    final sanitizedLabel = label.replaceAll(" ", "").toLowerCase();
    return "${prefix}_$sanitizedLabel";
  }

  @override
  Widget build(BuildContext context) {
    final String currentPrefix = parentKeyPrefix.isEmpty
        ? formType.replaceAll(" ", "").toLowerCase()
        : parentKeyPrefix;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.map((field) {
        final key = _generateKey(currentPrefix, field.fieldLabel);

        if (field.subFields != null && field.subFields!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.fieldLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Divider(),
                DynamicForm(
                  isNested: true,
                  formType: field.fieldLabel,
                  fields: field.subFields!,
                  controllers: controllers,
                  buttonIcon: buttonIcon,
                  constraints: constraints,
                  parentKeyPrefix: key,
                  model: model,
                ),
              ],
            ),
          );
        }

        bool shouldHideField = false;
        if (isNested) {
          final masterDropdownField = fields.firstWhere(
            (f) => f.options != null && f.options!.isNotEmpty,
            orElse: () => field,
          );

          if (masterDropdownField != field) {
            final currentSelection =
                selectedDropdownValues[masterDropdownField.fieldLabel];
            if (currentSelection == null || currentSelection.isEmpty) {
              shouldHideField = true;
            }
          }
        }

        return DynamicFieldItem(
          field: field,
          fieldKey: key,
          formType: formType,
          controller: controllers[key],
          shouldHideField: shouldHideField,
          onImagePicked: onImagePicked,
          onChanged: (newValue) =>
              onDropdownChanged(field.fieldLabel, key, newValue),
        );
      }).toList(),
    );
  }
}
