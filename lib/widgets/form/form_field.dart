import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/admin/users_provider.dart';

class FormFieldWidget extends ConsumerWidget {
  const FormFieldWidget({
    super.key,
    required this.fieldType,
    required this.formIcon,
    required this.formLabel,
    required this.controller,
    required this.type,
    this.id,
  });
  final IconData formIcon;
  final int? id;
  final String formLabel;
  final String fieldType;
  final TextEditingController controller;
  final String type;

  String? formValidator(String? label) {
    if (label == null || label.isEmpty) {
      return "$formLabel is required";
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (type == "Edit") {
      final user = ref.watch(userDetailProvider(id!));

      controller.text = user!.toJson([fieldType])["user"]![fieldType];
    }
    return Card(
      child: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12),
        child: ListTile(
          leading: Icon(formIcon),
          title: type == "Edit"
              ? TextFormField(
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  controller: controller,
                  obscureText: fieldType.toLowerCase() == 'password'
                      ? true
                      : false,
                  validator: (value) {
                    return formValidator(value);
                  },
                  decoration: InputDecoration(label: Text(formLabel)),
                )
              : TextFormField(
                  cursorColor: Theme.of(context).colorScheme.inversePrimary,
                  controller: controller,
                  obscureText: fieldType.toLowerCase() == 'password'
                      ? true
                      : false,
                  validator: (value) {
                    return formValidator(value);
                  },
                  decoration: InputDecoration(label: Text(formLabel)),
                ),
        ),
      ),
    );
  }
}
