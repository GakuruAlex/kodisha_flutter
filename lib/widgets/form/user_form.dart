import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/users_provider.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class UserForm extends ConsumerStatefulWidget {
  const UserForm({super.key, required this.type, this.id});
  final String type;
  final int? id;
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

    return Scaffold(
      appBar: AppBar(title: Text(widget.type)),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            FormFieldWidget(
              id: widget.id,
              type: widget.type,
              fieldType: "firstname",
              formIcon: Icons.person,
              formLabel: "Firstname",
              controller: _firstNameController,
            ),
            FormFieldWidget(
              type: widget.type,
              id: widget.id,

              fieldType: "lastname",
              formIcon: Icons.person,
              formLabel: "Lastname",
              controller: _lastNameController,
            ),
            FormFieldWidget(
              type: widget.type,
              id: widget.id,

              fieldType: "email_address",
              formIcon: Icons.email,
              formLabel: "Email",
              controller: _emailController,
            ),
            FormFieldWidget(
              type: widget.type,
              id: widget.id,

              fieldType: "phonenumber",
              formIcon: Icons.phone,
              formLabel: "Phone Number",
              controller: _phoneController,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .5,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: ElevatedButton(
                  onPressed: widget.type == "Edit"
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.type == "Edit") {
                              final user = ref.watch(
                                userDetailProvider(widget.id!),
                              );
                              userNotifierProvider.updateUser(
                                user!.copywith(
                                  firstname:
                                      user.firstname !=
                                          _firstNameController.text
                                      ? _firstNameController.text
                                      : null,
                                  lastname:
                                      user.lastname != _lastNameController.text
                                      ? _lastNameController.text
                                      : null,
                                  phonenumber:
                                      user.phonenumber != _phoneController.text
                                      ? _phoneController.text
                                      : null,
                                  emailAddress:
                                      user.emailAddress != _emailController.text
                                      ? _emailController.text
                                      : null,
                                ),
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${_firstNameController.text} Edited!",
                                ),
                              ),
                            );

                            Navigator.of(context).pop();
                          }
                        }
                      : () {
                          if (_formKey.currentState!.validate()) {
                            userNotifierProvider.addUser({
                              "firstname": _firstNameController.text,
                              "lastname": _lastNameController.text,
                              "phonenumber": _phoneController.text,
                              "email_address": _emailController.text,
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${_firstNameController.text} created!",
                                ),
                              ),
                            );

                            Navigator.of(context).pop();
                          }
                        },
                  child: ListTile(
                    leading: Icon(
                      Icons.person_add,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: Text(
                      "${widget.type} User",
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
