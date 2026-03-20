import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
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
          SizedBox(height: 20),

          ElevatedButton(
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(144, 50)),
              maximumSize: WidgetStatePropertyAll(Size(220, 50)),
              padding: WidgetStatePropertyAll(EdgeInsetsGeometry.all(12)),
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.primary,
              ),
            ),

            onPressed: () {
              print("Login button pressed");
              if (_formKey.currentState!.validate()) {
                loginProvider.loginUser(
                  _emailController.text,
                  _passwordController.text,
                );
              }
            },
            child: ListTile(
              leading: Icon(Icons.login),
              title: Text(
                "Login",
                style: Theme.of(context).textTheme.bodySmall,
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
              data: (data) => Card(child: Text(data["token"])),
              error: (error, statck) =>
                  SnackBar(content: Text("Login error: $error $statck")),
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
