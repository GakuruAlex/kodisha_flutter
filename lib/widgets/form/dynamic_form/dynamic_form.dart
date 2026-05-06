import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/actions/actions.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class DynamicForm extends ConsumerStatefulWidget {
  const DynamicForm({
    super.key,
    this.multipleImages,
    required this.formType,
    required this.fields,
    required this.controllers,
    required this.buttonIcon,
    required this.constraints,
    this.model,
    this.id,
  });
  final String formType;
  final bool? multipleImages;
  final List<DynamicFormField> fields;
  final Map<String, TextEditingController> controllers;
  final IconData buttonIcon;
  final Map<String, double> constraints;
  final FormModel? model;
  final int? id;

  @override
  ConsumerState<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends ConsumerState<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  List<XFile>? _images;
  @override
  Widget build(BuildContext context) {
    if (widget.formType.toLowerCase().contains("edit") &&
        widget.model != null) {
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
                children: widget.fields.map((field) {
                  final key = field.fieldLabel
                      .replaceAll(" ", "")
                      .toLowerCase();

                  return FormFieldWidget(
                    onImagePicked: (file, files) {
                      setState(() {
                        _image = file;
                        _images = files;
                      });
                    },
                    fieldType: field.fieldLabel,
                    formIcon: field.fieldIcon,
                    formLabel: field.fieldLabel,
                    controller: widget.controllers[key],
                    type: widget.formType,
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: widget.constraints["tileWidth"],

                child: FloatingActionButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      runAction(
                        buildAction(
                          widget.formType,
                          widget.controllers,
                          widget.model,
                          widget.id,
                          image: _image,
                          images: _images
                        ),
                        ref,
                      );
                      if (widget.formType.toLowerCase() != "login") {
                        Navigator.of(context).pop();
                      }
                    }
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
