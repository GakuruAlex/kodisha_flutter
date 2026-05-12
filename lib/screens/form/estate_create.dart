import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';
import 'package:kodisha_flutter/widgets/navigation/top_nav_bar.dart';
// Import where your theme/decorations are defined
// import 'package:kodisha_flutter/theme.dart';

class NewEstateForm extends StatefulWidget {
  const NewEstateForm({super.key});

  @override
  State<NewEstateForm> createState() => _NewEstateFormState();
}

class _NewEstateFormState extends State<NewEstateForm> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      "location": TextEditingController(),
      "name": TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        // The AppBar will use the background color from your Theme's appBarTheme automatically
        appBar: TopNavBar(title: "New House", isHome: false),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:
              loginContainerDecoration, // Applying your custom gradient here
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
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
                    DynamicFormField(
                      fieldLabel: "Image",
                      fieldIcon: Icons.image,
                    ),
                  ],
                  controllers: _controllers,
                  buttonIcon: Icons.add,
                  constraints: {
                    "pad": 20.0,
                    "height": screenSize.height * 0.8,
                    "Width": screenSize.width * .9,
                    "tileWidth": screenSize.width * .4,
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
