import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';
import 'package:kodisha_flutter/widgets/navigation/top_nav_bar.dart';

class NewEstateForm extends StatefulWidget {
  const NewEstateForm({super.key});

  @override
  State<NewEstateForm> createState() => _NewEstateFormState();
}

class _NewEstateFormState extends State<NewEstateForm> {
  // Using a dynamic map to avoid key mismatch errors
  final Map<String, TextEditingController> _controllers = {};
  // Inside _NewEstateFormState
  TextEditingController _getController(String label) {
    // DynamicForm usually does: formType.replaceAll(" ", "").toLowerCase()
    final String prefix = "createestate";
    // And: label.replaceAll(" ", "").toLowerCase()
    final String sanitizedLabel = label.replaceAll(" ", "").toLowerCase();
    final String key = "${prefix}_$sanitizedLabel";

    return _controllers.putIfAbsent(key, () => TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    // Pre-initialize the keys we are using in the DynamicForm below
    _getController("Name");
    _getController("Location");
    // "Image" usually handled via image picker, but we can init if needed
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

    return Scaffold(
      // Keep SafeArea inside the body or around Scaffold, but TopNavBar
      // usually handles its own padding or sits outside SafeArea.
      appBar: TopNavBar(title: "New Estate", isHome: false),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: loginContainerDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: DynamicForm(
                  formType: "Create Estate",
                  fields: const [
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
                  controllers: _controllers, // Now contains prefixed keys
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
