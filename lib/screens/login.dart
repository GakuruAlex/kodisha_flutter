import 'package:flutter/material.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/login_form.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.8,
          width: MediaQuery.sizeOf(context).width * .8,
          decoration: loginContainerDecoration,
          child: Card(elevation: 12, child: LoginForm()),
        ),
      ),
    );
  }
}
