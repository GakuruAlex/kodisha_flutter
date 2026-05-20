import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class DynamicFieldItem extends StatelessWidget {
  const DynamicFieldItem({
    super.key,
    required this.field,
    required this.fieldKey,
    required this.formType,
    required this.shouldHideField,
    required this.onImagePicked,
    required this.onChanged,
    this.controller,
  });

  final DynamicFormField field;
  final String fieldKey;
  final String formType;
  final bool shouldHideField;
  final TextEditingController? controller;
  final Function(XFile?, List<XFile>?) onImagePicked;
  final Function(String? newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: shouldHideField
          ? const SizedBox.shrink()
          : FormFieldWidget(
              onImagePicked: onImagePicked,
              fieldType: field.fieldLabel,
              formIcon: field.fieldIcon,
              formLabel: field.fieldLabel,
              controller: controller,
              type: formType,
              options: field.options,
              onChanged: onChanged,
            ),
    );
  }
}