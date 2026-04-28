import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/provider/admin/users_provider.dart';

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
  });
  final Function(XFile?)? onImagePicked;
  final IconData formIcon;
  final int? id;
  final String formLabel;
  final String fieldType;
  final TextEditingController? controller;
  final String type;

  @override
  ConsumerState<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends ConsumerState<FormFieldWidget> {
  String? formValidator(String? label) {
    if (label == null || label.isEmpty) {
      return "${widget.formLabel} is required";
    }
    return null;
  }

  XFile? _image;

  @override
  Widget build(BuildContext context) {
    if (widget.type == "Edit") {
      final user = ref.watch(userDetailProvider(widget.id!));
      widget.controller!.text = user!.toJson([
        widget.fieldType,
      ])["user"]![widget.fieldType];
    }

    Widget inputWidget;

    // 🔹 Decide what goes inside the card
    if (widget.fieldType.toLowerCase() == "image") {
      inputWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.formLabel),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final picked = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                setState(() {
                  _image = picked;
                });
                widget.onImagePicked?.call(picked);
              }
            },
            child: const Text(
              "Pick Image",
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          if (_image != null) Image.file(File(_image!.path), height: 100),
        ],
      );
    } else {
      inputWidget = TextFormField(
        cursorColor: Theme.of(context).colorScheme.inversePrimary,
        controller: widget.controller,
        obscureText: widget.fieldType.toLowerCase() == 'password',
        validator: (value) => formValidator(value),
        decoration: InputDecoration(label: Text(widget.formLabel)),
      );
    }

    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: ListTile(leading: Icon(widget.formIcon), title: inputWidget),
      ),
    );
  }
}
