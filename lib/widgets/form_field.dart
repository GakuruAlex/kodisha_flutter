import 'package:flutter/material.dart';

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    super.key,
    required this.fieldType,
    required this.formIcon,
    required this.formLabel,
    required this.controller,
  });
  final IconData formIcon;
  final String formLabel;
  final String fieldType;
  final TextEditingController controller;

  String? formValidator(String? label) {
    if (label == null || label.isEmpty) {
      return "$formLabel is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12.0, right: 12),
      child: ListTile(
        leading: Icon(formIcon),
        title: TextFormField(
          keyboardType: TextInputType.text,
          cursorColor: Theme.of(context).colorScheme.inversePrimary,
          controller: controller,
          obscureText: fieldType.toLowerCase() == 'password' ? true : false,
          validator: (value) {
            return formValidator(value);
          },
          decoration: InputDecoration(label: Text(formLabel)),
        ),
      ),
    );
  }
}
