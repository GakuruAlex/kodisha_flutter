import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/services/login_service.dart';

final loginNotifier = AsyncNotifierProvider<AsyncLoginNotifier, String>(
  () => AsyncLoginNotifier(),
);
final loginServiceProvider = Provider((ref) => LoginService());
final roleProvider = NotifierProvider<RoleNotifier, String>(
  () => RoleNotifier(),
);

class RoleNotifier extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void setRole(String role) {
    state = role;
  }
}

class AsyncLoginNotifier extends AsyncNotifier<String> {
  @override
  String build() {
    return '';
  }

  Future<void> loginUser(String email, String password) async {
    final loginService = ref.read(loginServiceProvider);
    state = AsyncLoading();
    try {
      final response = await loginService.login(email, password);
      state = AsyncValue.data(response["token"]);
      if (response.isNotEmpty) {
        ref.read(roleProvider.notifier).setRole(response["user"]["role"]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
