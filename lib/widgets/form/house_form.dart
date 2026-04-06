import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class HouseForm extends ConsumerStatefulWidget {
  const HouseForm({super.key, required this.estateId});

  final int estateId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HouseFormState();
  }
}

class _HouseFormState extends ConsumerState<HouseForm> {
  final _houseFormKey = GlobalKey<FormState>();
  final _houseNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(12),
      child: Form(
        key: _houseFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormFieldWidget(
              fieldType: "House name",
              formIcon: Icons.house,
              formLabel: "House Name",
              controller: _houseNameController,
              type: "New",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_houseFormKey.currentState!.validate()) {
                  ref
                      .read(housesNotifierProvider(widget.estateId).notifier)
                      .addHouse(House(name: _houseNameController.text));

                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "Submit",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
