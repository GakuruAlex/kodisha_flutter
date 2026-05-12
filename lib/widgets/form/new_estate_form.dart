import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';

class NewEstate extends StatelessWidget {
  NewEstate({super.key});

  final controllers = {
    "location": TextEditingController(),
    "name": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DynamicForm(
          formType: "Create Estate",
          fields: [
            DynamicFormField(
              fieldLabel: "Name",
              textInputType: TextInputType.text,
              fieldIcon: Icons.house,
            ),
            DynamicFormField(
              fieldLabel: "Location",
              textInputType: TextInputType.text,
              fieldIcon: Icons.place,
            ),
            DynamicFormField(fieldLabel: "Image", fieldIcon: Icons.image),
          ],
          controllers: controllers,
          buttonIcon: Icons.add,
          constraints: {
            "pad": 20,
            "height": MediaQuery.sizeOf(context).height,
            "Width": MediaQuery.sizeOf(context).width * .9,
            "tileWidth": MediaQuery.sizeOf(context).width * .4,
          },
        ),
      ),
    );
  }
}
