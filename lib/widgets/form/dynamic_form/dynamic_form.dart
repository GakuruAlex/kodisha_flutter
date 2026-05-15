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
    _syncControllersToDropdownState();
  }

  // Standardized key generator to use across the widget
  String _generateKey(String prefix, String label) {
    final sanitizedLabel = label.replaceAll(" ", "").toLowerCase();
    return "${prefix}_$sanitizedLabel";
  }

  void _syncControllersToDropdownState() {
    final currentPrefix = widget.parentKeyPrefix.isEmpty
        ? widget.formType.replaceAll(" ", "").toLowerCase()
        : widget.parentKeyPrefix;

    for (var field in widget.fields) {
      if (field.options != null && field.options!.isNotEmpty) {
        final key = _generateKey(currentPrefix, field.fieldLabel);

        if (widget.controllers.containsKey(key) &&
            widget.controllers[key]!.text.isNotEmpty) {
          _selectedDropdownValues[field.fieldLabel] =
              widget.controllers[key]!.text;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentPrefix = widget.parentKeyPrefix.isEmpty
        ? widget.formType.replaceAll(" ", "").toLowerCase()
        : widget.parentKeyPrefix;

    // Handle Edit Mode values
    if (widget.formType.toLowerCase().contains("edit") &&
        widget.model != null) {
      final values = widget.model!.toFormValues();
      widget.controllers.forEach((key, controller) {
        if (values.containsKey(key)) {
          controller.text = values[key].toString();
        }
      });
    }

    final fieldsLayout = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.map((field) {
        // --- KEY GENERATION FIX ---
        // Removed the conditional check. Every field now gets a prefixed key.
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
                  controllers: widget.controllers,
                  buttonIcon: widget.buttonIcon,
                  constraints: widget.constraints,
                  parentKeyPrefix: key,
                ),
              ],
            ),
          );
        }

        bool shouldHideField = false;
        if (widget.isNested) {
          final masterDropdownField = widget.fields.firstWhere(
            (f) => f.options != null && f.options!.isNotEmpty,
            orElse: () => field,
          );

          if (masterDropdownField != field) {
            final currentSelection =
                _selectedDropdownValues[masterDropdownField.fieldLabel];
            if (currentSelection == null || currentSelection.isEmpty) {
              shouldHideField = true;
            }
          }
        }

        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: shouldHideField
              ? const SizedBox.shrink()
              : FormFieldWidget(
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
                  options: field.options,
                  onChanged: (newValue) {
                    if (field.options != null && field.options!.isNotEmpty) {
                      setState(() {
                        _selectedDropdownValues[field.fieldLabel] = newValue;
                        widget.controllers[key]?.text = newValue ?? "";
                      });
                    }
                  },
                ),
        );
      }).toList(),
    );

    if (widget.isNested) return fieldsLayout;

    return Padding(
      padding: EdgeInsets.all(widget.constraints["pad"] ?? 16.0),
      child: SizedBox(
        // Safety check for 'Width' vs 'width'
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
