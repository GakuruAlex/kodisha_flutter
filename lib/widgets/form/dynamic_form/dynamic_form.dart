import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class DynamicForm extends StatelessWidget {
  const DynamicForm({
    super.key,
    required this.formType,
    required this.fields,
    required this.controllers,
  });
  final String formType;
  final List<DynamicFormField> fields;
  final Map<String, TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    if (formType.toLowerCase() == "edit") {
      controllers.entries.map((entry) => entry.value.text = "PlaceHolder Text");
    }
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .5,
        width: MediaQuery.sizeOf(context).width * .9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: fields
              .map(
                (field) => FormFieldWidget(
                  fieldType: field.fieldLabel,
                  formIcon: field.fieldIcon,
                  formLabel: field.fieldLabel,
                  controller:
                      controllers[field.fieldLabel
                          .replaceAll(" ", "")
                          .toLowerCase()]!,
                  type: formType,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
