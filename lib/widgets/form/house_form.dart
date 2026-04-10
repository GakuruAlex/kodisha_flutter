import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';

class HouseForm extends StatelessWidget {
  const HouseForm({super.key, required this.estateId});

  final int estateId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(12),
      child: DynamicForm(
        formType: "create house",
        fields: [
          DynamicFormField(
            fieldLabel: "House Name",
            textInputType: TextInputType.text,
            fieldIcon: Icons.house,
          ),
        ],
        controllers: {"house name": TextEditingController()},
        buttonIcon: Icons.create,
        constraints: {},
      ),
    );
  }
}
