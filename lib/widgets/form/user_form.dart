import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/users_provider.dart';
import 'package:kodisha_flutter/widgets/form_field.dart';

class UserForm extends ConsumerStatefulWidget {
  const UserForm({super.key});

  @override
  ConsumerState<UserForm> createState() => _UserFormState();
}

class _UserFormState extends ConsumerState<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userNotifierProvider = ref.read(userNotifier.notifier);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FormFieldWidget(
            fieldType: "firstname",
            formIcon: Icons.person,
            formLabel: "Firstname",
            controller: _firstNameController,
          ),
          FormFieldWidget(
            fieldType: "lastname",
            formIcon: Icons.person,
            formLabel: "Lastname",
            controller: _lastNameController,
          ),
          FormFieldWidget(
            fieldType: "email",
            formIcon: Icons.email,
            formLabel: "Email",
            controller: _emailController,
          ),
          FormFieldWidget(
            fieldType: "phone",
            formIcon: Icons.phone,
            formLabel: "Phone Number",
            controller: _phoneController,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * .5,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Submit");
                    userNotifierProvider.addUser({
                      "firstname": _firstNameController.text,
                      "lastname": _lastNameController.text,
                      "phonenumber": _phoneController.text,
                      "email_address": _emailController.text,
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: ListTile(
                  leading: Icon(
                    Icons.person_add,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text(
                    "Add User",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
