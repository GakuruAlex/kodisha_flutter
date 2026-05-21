import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/estate_model.dart'; 
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
    final colorScheme = Theme.of(context).colorScheme;
    
    final Map<String, double> constraints = {
      "width": size.width,
      "pad": 16.0,
      "tileWidth": size.width * 0.85,
    };

    
    final currentImageUrl = widget.estate.imageUrl; 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Estate Summary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            Container(
              width: constraints["tileWidth"] ?? size.width * 0.85,
              height: 180,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: currentImageUrl != null && currentImageUrl.isNotEmpty
                    ? Image.network(
                        currentImageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 40, color: colorScheme.error),
                            const SizedBox(height: 8),
                            Text(
                              "Failed to load image preview",
                              style: TextStyle(color: colorScheme.onErrorContainer, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 44, color: colorScheme.onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text(
                            "No existing image uploaded",
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 8),

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