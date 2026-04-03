import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/screens/admin/kodisha_homepage.dart';
import 'package:kodisha_flutter/pages/landlord/landlord_homepage.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/widgets/form/form_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginSuccess = ref.watch(loginNotifier);
    final loginProvider = ref.read(loginNotifier.notifier);

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
          ref.read(estatesProvider.notifier).landlordEstates();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => LandlordHomepage()),
          );
          break;
        default:
          break;
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormFieldWidget(
            type: "Login",
            fieldType: "email",
            formLabel: "Email Address",
            formIcon: Icons.email,
            controller: _emailController,
          ),
          SizedBox(height: 40),
          FormFieldWidget(
            type: "Login",
            fieldType: "password",
            formIcon: Icons.password,
            formLabel: "Password",
            controller: _passwordController,
          ),
          SizedBox(height: 40),

          SizedBox(
            width: MediaQuery.sizeOf(context).width * .5,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    loginProvider.loginUser(
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
                child: ListTile(
                  leading: Icon(
                    Icons.login,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  title: Text(
                    "Login",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
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
