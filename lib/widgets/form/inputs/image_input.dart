import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/theme/main_theme.dart'; // Ensure colorsScheme is accessible

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
      crossAxisAlignment:
          CrossAxisAlignment.center, // Center the button and images
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorsScheme.primary, // Match your "Image" heading style
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 12),

        // Styled Button
        ElevatedButton.icon(
          onPressed: () async {
            final picker = ImagePicker();
            if (widget.isMulti) {
              final picked = await picker.pickMultiImage();
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
          icon: Icon(Icons.add_a_photo, color: colorsScheme.primary),
          label: Text(
            "Pick ${widget.label}",
            style: TextStyle(
              color: colorsScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                colorsScheme.onPrimary, // High contrast yellow/gold
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Preview area with a border/rounded corners
        if (_image != null || (_images != null && _images!.isNotEmpty))
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.isMulti
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _images!
                        .map(
                          (img) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(img.path),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        .toList(),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_image!.path),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
      ],
    );
  }
}
