import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/actions/actions.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class DynamicForm extends ConsumerStatefulWidget {
  DynamicForm({
    super.key,
    required this.formType,
    required this.fields,
    required this.controllers,
    required this.buttonIcon,
    required this.constraints,
    this.model,
  });
  final String formType;
  final List<DynamicFormField> fields;
  final Map<String, TextEditingController> controllers;
  final IconData buttonIcon;
  final Map<String, double> constraints;
  FormModel? model;

  @override
  ConsumerState<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends ConsumerState<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (widget.formType.toLowerCase() == "edit" && widget.model != null) {
      final values = widget.model!.toFormValues();
      widget.controllers.forEach((key, controller) {
        if (values.containsKey(key)) {
          controller.text = values[key].toString();
        }
      });
    }

    return Padding(
      padding: EdgeInsetsGeometry.all(widget.constraints["pad"]!),
      child: SizedBox(
        height: widget.constraints["height"],
        width: widget.constraints["width"],
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: widget.fields
                    .map(
                      (field) => FormFieldWidget(
                        fieldType: field.fieldLabel,
                        formIcon: field.fieldIcon,
                        formLabel: field.fieldLabel,
                        controller:
                            widget.controllers[field.fieldLabel
                                .replaceAll(" ", "")
                                .toLowerCase()]!,
                        type: widget.formType,
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: widget.constraints["tileWidth"],

                child: FloatingActionButton(
                  onPressed: () {
                    runAction(
                      buildAction(
                        widget.formType,
                        widget.controllers,
                        widget.model,
                      ),
                      ref,
                    );
                  },
                  child: ListTile(
                    leading: Icon(widget.buttonIcon),
                    title: Text(widget.formType),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
