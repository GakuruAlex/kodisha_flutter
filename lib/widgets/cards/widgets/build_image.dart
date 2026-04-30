import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class BuildImage extends StatelessWidget {
  const BuildImage({super.key, this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(color: Colors.grey[300], child: const Icon(Icons.image));
    }
    return FadeInImage(
      fit: BoxFit.cover,
      placeholder: MemoryImage(kTransparentImage),
      image: NetworkImage(imageUrl!),
    );
  }
}
