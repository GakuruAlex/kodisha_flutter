import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/estate_model.dart'; // Adjust path if needed
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';

class EditEstateScreen extends ConsumerStatefulWidget {
  const EditEstateScreen({
    super.key,
    required this.estate,
  });

  final Estate estate;

  @override
  ConsumerState<EditEstateScreen> createState() => _EditEstateScreenState();
}

class _EditEstateScreenState extends ConsumerState<EditEstateScreen> {
  final Map<String, TextEditingController> _formControllers = {};
  //bool _hasPickedNewImage = false;

  final List<DynamicFormField> _estateFields = [
    DynamicFormField(
      fieldLabel: 'Name',
      fieldIcon: Icons.business,
    ),
    DynamicFormField(
      fieldLabel: 'Location',
      fieldIcon: Icons.location_on,
    ),
    DynamicFormField(fieldLabel: 'Estate Image', fieldIcon: Icons.image),
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormControllers();
  }

  void _initializeFormControllers() {
    const formType = "editestate"; 

    for (var field in _estateFields) {
      final sanitizedLabel = field.fieldLabel.replaceAll(" ", "").toLowerCase();
      final key = "${formType}_$sanitizedLabel";

      _formControllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _formControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    final Map<String, double> constraints = {
      "width": size.width,
      "pad": 16.0,
      "tileWidth": size.width * 0.85,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Estate Summary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DynamicForm(
              formType: "Edit Estate", 
              fields: _estateFields,
              controllers: _formControllers,
              buttonIcon: Icons.save,
              constraints: constraints,
              model: widget.estate, 
              id: widget.estate.id,
            ),
          ],
        ),
      ),
    );
  }
}