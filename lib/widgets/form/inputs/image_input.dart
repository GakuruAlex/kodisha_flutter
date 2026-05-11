import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final String label;
  final bool isMulti;
  final Function(XFile?, List<XFile>?) onImagePicked;

  const ImageInput({
    super.key,
    required this.label,
    required this.isMulti,
    required this.onImagePicked,
  });

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? _image;
  List<XFile>? _images;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final picker = ImagePicker();
            if (widget.isMulti) {
              final picked = await picker.pickMultiImage(
                requestFullMetadata: true,
              );
              if (picked.isNotEmpty) {
                setState(() => _images = picked);
                widget.onImagePicked(null, picked);
              }
            } else {
              final picked = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (picked != null) {
                setState(() => _image = picked);
                widget.onImagePicked(picked, null);
              }
            }
          },
          child: Text(
            "Pick ${widget.label}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (_image != null) Image.file(File(_image!.path), height: 100),
        if (_images != null)
          Wrap(
            spacing: 8,
            children: _images!
                .map((img) => Image.file(File(img.path), height: 100))
                .toList(),
          ),
      ],
    );
  }
}
