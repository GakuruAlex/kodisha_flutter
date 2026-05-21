import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/actions/form_builder.dart';
import 'package:kodisha_flutter/actions/form_executor.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'dynamic_fields_layout.dart';
import 'dynamic_form_state_mixin.dart'; // Import mixin file

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
    this.isNested = false,
    this.parentKeyPrefix = "",
  });

  final String formType;
  final bool? multipleImages;
  final List<DynamicFormField> fields;
  final Map<String, TextEditingController> controllers;
  final IconData buttonIcon;
  final Map<String, double> constraints;
  final FormModel? model;
  final int? id;
  final bool isNested;
  final String parentKeyPrefix;

  @override
  ConsumerState<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends ConsumerState<DynamicForm> with DynamicFormStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    populateEditValues();
    syncControllersToDropdownState();
  }

  @override
  Widget build(BuildContext context) {
    final fieldsLayout = DynamicFieldsLayout(
      fields: widget.fields,
      controllers: widget.controllers,
      formType: widget.formType,
      constraints: widget.constraints,
      parentKeyPrefix: widget.parentKeyPrefix,
      isNested: widget.isNested,
      model: widget.model,
      buttonIcon: widget.buttonIcon,
      selectedDropdownValues: selectedDropdownValues,
      onImagePicked: updateImageState,
      onDropdownChanged: updateDropdownState,
    );

    if (widget.isNested) return fieldsLayout;

    return Padding(
      padding: EdgeInsets.all(widget.constraints["pad"] ?? 16.0),
      child: SizedBox(
        width: widget.constraints["width"] ?? widget.constraints["Width"],
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              fieldsLayout,
              const SizedBox(height: 10),
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
                          image: image,
                          images: images,
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