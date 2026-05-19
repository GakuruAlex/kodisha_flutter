import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';
import 'package:kodisha_flutter/theme/main_theme.dart'; // Ensure theme is imported
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';
import 'package:kodisha_flutter/widgets/navigation/top_nav_bar.dart';

class HouseFormPage extends StatefulWidget {
  const HouseFormPage({super.key, required this.estateId});

  final int estateId;

  @override
  State<HouseFormPage> createState() => _HouseFormPageState();
}

class _HouseFormPageState extends State<HouseFormPage> {
  final Map<String, TextEditingController> _controllers = {};

  // 2. Helper function to get or create a controller safely
  TextEditingController _getController(String label, {String? parent}) {
    final String prefix = "createhouse"; // Matches your formType
    final String sanitizedLabel = label.replaceAll(" ", "").toLowerCase();

    // Construct the key exactly how DynamicForm does it
    final String key = parent != null
        ? "${prefix}_${parent.replaceAll(" ", "").toLowerCase()}_$sanitizedLabel"
        : "${prefix}_$sanitizedLabel";

    return _controllers.putIfAbsent(key, () => TextEditingController());
  }

  @override
  void initState() {
    super.initState();
    // 3. Pre-initialize the specific controllers you need
    _getController("House Name");
    _getController("House Type");
    _getController("Is Occupied");

    // Sub-fields for utilities
    _getController("Utility Name", parent: "utilities");
    _getController("Meter no", parent: "utilities");
    _getController("Last Reading", parent: "utilities");
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
      // TopNavBar with the back button logic (isHome: false)
      appBar: TopNavBar(title: "Create New House", isHome: false),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Using your theme's gradient decoration
        decoration: loginContainerDecoration,
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
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

                    DynamicFormField(
                      fieldLabel: "utilities",
                      fieldIcon: Icons.water,
                      subFields: [
                        DynamicFormField(
                          fieldLabel: "Utility Name",
                          fieldIcon: Icons.category,
                          options: AccountName.values
                              .map((element) => element.uiValue)
                              .toList(),
                        ),
                        DynamicFormField(
                          fieldLabel: "Meter no",
                          fieldIcon: Icons.gas_meter,
                        ),
                        DynamicFormField(
                          fieldLabel: "Last Reading",
                          fieldIcon: Icons.gas_meter,
                        ),
                      ],
                    ),

                    const DynamicFormField(
                      fieldLabel: "Images",
                      fieldIcon: Icons.image,
                    ),
                  ],
                  controllers: _controllers,
                  buttonIcon: Icons.add_home_work,
                  constraints: {
                    "pad": 20.0,
                    "height": screenSize.height * 0.8,
                    "Width": screenSize.width * 0.9,
                    "tileWidth":
                        screenSize.width * 0.4, // Matches Estate form button
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
