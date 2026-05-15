import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: deprecated_member_use
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: IconButton(
        icon: const Icon(Icons.delete_forever, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
