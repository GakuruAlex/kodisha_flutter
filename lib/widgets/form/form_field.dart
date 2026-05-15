// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/provider/admin/users_provider.dart';
import 'inputs/dropdown_input.dart';
import 'inputs/image_input.dart';

class FormFieldWidget extends ConsumerStatefulWidget {
  const FormFieldWidget({
    this.onImagePicked,
    super.key,
    required this.fieldType,
    required this.formIcon,
    required this.formLabel,
    this.controller,
    required this.type,
    this.id,
    this.options,
    this.onChanged, // Added this callback to pass selection state upwards
  });

  final Function(XFile?, List<XFile>?)? onImagePicked;
  final IconData formIcon;
  final int? id;
  final String formLabel;
  final String fieldType;
  final TextEditingController? controller;
  final String type;
  final List<String>? options;
  final ValueChanged<String?>? onChanged; // Callback type definition

  @override
  ConsumerState<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends ConsumerState<FormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == "Edit" && widget.id != null) {
      final user = ref.watch(userDetailProvider(widget.id!));
      if (user != null && widget.controller?.text.isEmpty == true) {
        widget.controller?.text =
            user.toJson([widget.fieldType])["user"]![widget.fieldType] ?? "";
      }
    }

    final inputDecoration = InputDecoration(
      labelText: widget.formLabel,
      prefixIcon: Icon(widget.formIcon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.05),
    );

    Widget inputWidget;

    if (widget.fieldType.toLowerCase().contains("image")) {
      inputWidget = ImageInput(
        label: widget.formLabel,
        isMulti: widget.fieldType.toLowerCase() == "images",
        onImagePicked: widget.onImagePicked ?? (f, fs) {},
      );
    } else if (widget.options != null && widget.options!.isNotEmpty) {
      inputWidget = DropdownInput(
        label: widget.formLabel,
        options: widget.options!,
        controller: widget.controller,
        onChanged: widget.onChanged,
      );
    } else {
      inputWidget = TextFormField(
        controller: widget.controller,
        obscureText: widget.fieldType.toLowerCase() == 'password',
        decoration: inputDecoration,
        validator: (val) => (val == null || val.isEmpty)
            ? "${widget.formLabel} is required"
            : null,
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
        child: inputWidget,
      ),
    );
  }
}
