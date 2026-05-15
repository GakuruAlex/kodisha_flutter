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
    this.parentKeyPrefix = "", // Track deeply nested namespaces
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

  // Track the selected dropdown values locally to drive conditional visibility
  final Map<String, String?> _selectedDropdownValues = {};

  @override
  void initState() {
    super.initState();
    // Initialize dropdown states if they already have values in controllers
    _syncControllersToDropdownState();
  }

  void _syncControllersToDropdownState() {
    for (var field in widget.fields) {
      if (field.options != null && field.options!.isNotEmpty) {
        final currentPrefix = widget.parentKeyPrefix.isEmpty
            ? widget.formType.replaceAll(" ", "").toLowerCase()
            : widget.parentKeyPrefix;
        final key =
            "${currentPrefix}_${field.fieldLabel.replaceAll(" ", "").toLowerCase()}";

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
    final bool hashSubFields = widget.fields.any(
      (f) => f.subFields != null && f.subFields!.isNotEmpty,
    );
    if (widget.formType.toLowerCase().contains("edit") &&
        widget.model != null) {
      final values = widget.model!.toFormValues();
      widget.controllers.forEach((key, controller) {
        if (values.containsKey(key)) {
          controller.text = values[key].toString();
        }
      });
    }

    final String currentPrefix = widget.parentKeyPrefix.isEmpty
        ? widget.formType.replaceAll(" ", "").toLowerCase()
        : widget.parentKeyPrefix;

    final fieldsLayout = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.map((field) {
        final sanitizedLabel = field.fieldLabel
            .replaceAll(" ", "")
            .toLowerCase();
        final key = (hashSubFields || widget.isNested)
            ? "${currentPrefix}_$sanitizedLabel"
            : sanitizedLabel;
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
                  parentKeyPrefix: key, // Pass forward down the prefix chain
                ),
              ],
            ),
          );
        }

        // --- CONDITIONAL VISIBILITY LAYER (THE UTILITY TRICK) ---
        // If this field is a child field of a dropdown selector (like checking if Meter No/Reading is relevant)
        // We look up the parent container's conditional visibility status.
        bool shouldHideField = false;

        if (widget.isNested) {
          // If the sibling selector has options but no selection has been made, hide secondary structural inputs
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

        // Animated shrink away layout if conditional rules flag concealment
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
                  // Catch selection changes directly on fields containing options to toggle UI branches
                  onChanged: (newValue) {
                    if (field.options != null && field.options!.isNotEmpty) {
                      setState(() {
                        _selectedDropdownValues[field.fieldLabel] = newValue;
                        // Synchronize immediately to controller map
                        widget.controllers[key]?.text = newValue ?? "";
                      });
                    }
                  },
                ),
        );
      }).toList(),
    );

    if (widget.isNested) {
      return fieldsLayout;
    }

    return Padding(
      padding: EdgeInsets.all(widget.constraints["pad"]!),
      child: SizedBox(
        width: widget.constraints["width"],
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
