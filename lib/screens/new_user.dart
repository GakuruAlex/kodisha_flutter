import 'package:flutter/material.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/form/user_form.dart';

class NewUser extends StatelessWidget {
  const NewUser({super.key});
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a new user")),
      body: Center(
        child: Container(
          decoration: loginContainerDecoration,

          height: MediaQuery.sizeOf(context).height * 0.88,
          width: MediaQuery.sizeOf(context).width * .98,
          child: Card(child: UserForm(type: "New")),
        ),
      ),
    );
  }
}
