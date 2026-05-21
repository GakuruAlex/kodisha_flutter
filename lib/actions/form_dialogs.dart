import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context, String modelName) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text("Delete $modelName"),
      content: const Text("Do you accept ?"),
      elevation: 24,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Yes", style: Theme.of(context).textTheme.titleSmall),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel", style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    ),
  );
  return result ?? false;
}