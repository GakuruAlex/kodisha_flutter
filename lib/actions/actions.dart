import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';

sealed class ActionInput {}

class LoginInput extends ActionInput {
  LoginInput({required this.email, required this.password});
  final String email;
  final String password;
}

void runAction(ActionInput action, WidgetRef ref) {
  switch (action) {
    case LoginInput(:String email, :String password):
      ref.read(loginNotifier.notifier).loginUser(email, password);
  }
}
