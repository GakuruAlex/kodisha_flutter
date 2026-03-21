import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/services/login_service.dart';

final loginNotifier = AsyncNotifierProvider<AsyncLoginNotifier, String>(
  () => AsyncLoginNotifier(),
);
final loginServiceProvider = Provider((ref) => LoginService());

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
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
