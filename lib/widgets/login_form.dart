import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/screens/kodisha_homepage.dart';
import 'package:kodisha_flutter/widgets/form_field.dart';

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
    ref.listen(loginNotifier, (previous, next) {
      next.whenOrNull(
        data: (data) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => KodishaHomepage()),
          );
        },
      );
    });
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FormFieldWidget(
            fieldType: "email",
            formLabel: "Email Address",
            formIcon: Icons.email,
            controller: _emailController,
          ),
          SizedBox(height: 20),
          FormFieldWidget(
            fieldType: "password",
            formIcon: Icons.password,
            formLabel: "Password",
            controller: _passwordController,
          ),
          SizedBox(height: 8),

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
          SizedBox(height: 20),
          Text(
            "Dont have an account Sign Up!",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(
            child: loginSuccess.when(
              data: (data) => const SizedBox.shrink(),
              error: (error, statck) => Text("$error"),
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
