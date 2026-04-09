import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/form_field.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/screens/admin/kodisha_homepage.dart';
import 'package:kodisha_flutter/pages/landlord/landlord_homepage.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/widgets/form/dynamic_form/dynamic_form.dart';

class LoginForm extends ConsumerWidget {
  LoginForm({super.key});

  final controllers = {
    "emailaddress": TextEditingController(),
    "password": TextEditingController(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginSuccess = ref.watch(loginNotifier);

    ref.listen<AuthRoleState>(authRoleProvider, (prev, next) {
      switch (next) {
        case AuthRoleState.loggedOut:
          ref.invalidate(loginNotifier);
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (ctx) => Login()));
          break;
        case AuthRoleState.admin:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => KodishaHomepage()),
          );
          break;
        case AuthRoleState.member:
          //ref.read(estatesProvider.notifier).landlordEstates();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => LandlordHomepage()),
          );
          break;
        default:
          break;
      }
    });

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .4,
            width: MediaQuery.sizeOf(context).width * .9,

            child: DynamicForm(
              constraints: {
                "height ": MediaQuery.sizeOf(context).height * .4,
                "width": MediaQuery.sizeOf(context).width * .9,
                "pad": 20.0,
                "tileWidth": MediaQuery.sizeOf(context).width * .4,
              },
              controllers: controllers,
              formType: "Login",
              buttonIcon: Icons.login,
              fields: [
                DynamicFormField(
                  fieldLabel: "Email Address",
                  textInputType: TextInputType.emailAddress,
                  fieldIcon: Icons.email,
                ),
                DynamicFormField(
                  fieldLabel: "Password",
                  textInputType: TextInputType.text,
                  fieldIcon: Icons.password,
                ),
              ],
            ),
          ),
          SizedBox(
            child: loginSuccess.when(
              data: (data) => const SizedBox.shrink(),
              error: (error, statck) => Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Text(
                  "$error",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
