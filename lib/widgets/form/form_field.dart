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
  });

  final Function(XFile?, List<XFile>?)? onImagePicked;
  final IconData formIcon;
  final int? id;
  final String formLabel;
  final String fieldType;
  final TextEditingController? controller;
  final String type;
  final List<String>? options;

  @override
  ConsumerState<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends ConsumerState<FormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    // Handle Edit Logic
    if (widget.type == "Edit" && widget.id != null) {
      final user = ref.watch(userDetailProvider(widget.id!));
      if (user != null) {
        widget.controller?.text = user.toJson([widget.fieldType])["user"]![widget.fieldType] ?? "";
      }
    }

    Widget inputWidget;

    // Determine which widget to render
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
        validator: (val) => (val == null || val.isEmpty) ? "${widget.formLabel} is required" : null,
      );
    } else {
      inputWidget = TextFormField(
        controller: widget.controller,
        obscureText: widget.fieldType.toLowerCase() == 'password',
        decoration: InputDecoration(label: Text(widget.formLabel), border: InputBorder.none),
        validator: (val) => (val == null || val.isEmpty) ? "${widget.formLabel} is required" : null,
      );
    }

    return Card(
      child: ListTile(
        leading: Icon(widget.formIcon),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: inputWidget,
        ),
      ),
    );
  }
}