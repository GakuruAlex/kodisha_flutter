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
      child: SingleChildScrollView(
        child: DynamicForm(
          id: estateId,
          formType: "Create House",
          fields: [
            DynamicFormField(
              fieldLabel: "House Name",
              textInputType: TextInputType.text,
              fieldIcon: Icons.house,
            ),
            DynamicFormField(fieldLabel: "Images", fieldIcon: Icons.image),
          ],
          controllers: {"housename": TextEditingController()},
          buttonIcon: Icons.create,
          constraints: {
            "pad": 20,
            "height": MediaQuery.sizeOf(context).height * .7,
            "width": MediaQuery.sizeOf(context).width * .8,
            "tileWidth": MediaQuery.sizeOf(context).width * .4,
          },
        ),
      ),
    );
  }
}
