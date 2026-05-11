import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';

class HouseFormPage extends StatefulWidget {
  const HouseFormPage({super.key, required this.estateId});

  final int estateId;

  @override
  State<HouseFormPage> createState() => _HouseFormPageState();
}

class _HouseFormPageState extends State<HouseFormPage> {
  final Map<String, TextEditingController> _controllers = {
    "housename": TextEditingController(),
    "housetype": TextEditingController(),
    "isoccupied": TextEditingController(),
  };

  @override
  void dispose() {
    // Clean up controllers when the page is destroyed
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New House"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Keyboard dismissal when clicking outside
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DynamicForm(
              id: widget.estateId,
              formType: "Create House",
              fields: [
                const DynamicFormField(
                  fieldLabel: "House Name",
                  textInputType: TextInputType.text,
                  fieldIcon: Icons.house,
                ),
                DynamicFormField(
                  fieldLabel: "House Type",
                  fieldIcon: Icons.select_all,
                  options: HouseType.values.map((v) => v.value).toList(),
                ),
                DynamicFormField(
                  fieldLabel: "Is Occupied",
                  fieldIcon: Icons.toggle_on,
                  options: IsOccupied.values.map((v) => v.value).toList(),
                ),
                const DynamicFormField(
                  fieldLabel: "Images", 
                  fieldIcon: Icons.image
                ),
              ],
              controllers: _controllers,
              buttonIcon: Icons.add_home_work,
              constraints: {
                "pad": 0.0, // Padding handled by the page wrapper
                "height": double.infinity, // Let the content define the height
                "width": MediaQuery.sizeOf(context).width, // Occupy full width
                "tileWidth": MediaQuery.sizeOf(context).width * 0.9, // Button width
              },
            ),
          ),
        ),
      ),
    );
  }
}