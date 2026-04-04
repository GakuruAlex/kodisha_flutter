import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class NewEstateForm extends ConsumerStatefulWidget {
  const NewEstateForm({super.key});

  @override
  ConsumerState<NewEstateForm> createState() => _NewEstateFormState();
}

class _NewEstateFormState extends ConsumerState<NewEstateForm> {
  final _formKey = GlobalKey<FormState>();
  final _estateNameController = TextEditingController();
  final _estateLocationController = TextEditingController();

  @override
  void dispose() {
    _estateNameController.dispose();
    _estateLocationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            FormFieldWidget(
              fieldType: "Estate name",
              formIcon: Icons.house,
              formLabel: "Estate Name",
              controller: _estateNameController,
              type: "New",
            ),
            FormFieldWidget(
              fieldType: "Estate location",
              formIcon: Icons.place,
              formLabel: "Estate location",
              controller: _estateLocationController,
              type: "New",
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .6,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(estatesProvider.notifier).addEstate({
                        "location": _estateLocationController.value.text,
                        "name": _estateNameController.value.text,
                      });
                    }
                    _formKey.currentState!.reset();
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: Text(
                      "Add Estate",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
