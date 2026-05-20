import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/actions/actions.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'dynamic_fields_layout.dart';

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

class _DynamicFormState extends ConsumerState<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? _image;
  List<XFile>? _images;
  final Map<String, String?> _selectedDropdownValues = {};

  @override
  void initState() {
    super.initState();
    _populateEditValues();
    _syncControllersToDropdownState();
  }

  void _populateEditValues() {
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

  void _syncControllersToDropdownState() {
    final currentPrefix = widget.parentKeyPrefix.isEmpty
        ? widget.formType.replaceAll(" ", "").toLowerCase()
        : widget.parentKeyPrefix;

    for (var field in widget.fields) {
      if (field.options != null && field.options!.isNotEmpty) {
        final sanitizedLabel = field.fieldLabel.replaceAll(" ", "").toLowerCase();
        final key = "${currentPrefix}_$sanitizedLabel";

        if (widget.controllers.containsKey(key) && widget.controllers[key]!.text.isNotEmpty) {
          _selectedDropdownValues[field.fieldLabel] = widget.controllers[key]!.text;
        }
      }
    }
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
      selectedDropdownValues: _selectedDropdownValues,
      onImagePicked: (file, files) {
        setState(() {
          _image = file;
          _images = files;
        });
      },
      onDropdownChanged: (fieldLabel, key, newValue) {
        setState(() {
          _selectedDropdownValues[fieldLabel] = newValue;
          widget.controllers[key]?.text = newValue ?? "";
        });
      },
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
                          image: _image,
                          images: _images,
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