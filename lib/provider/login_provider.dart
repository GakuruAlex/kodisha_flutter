import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/services/login_service.dart';

final loginNotifier =
    AsyncNotifierProvider<AsyncLoginNotifier, Map<String, dynamic>>(
      () => AsyncLoginNotifier(),
    );
final loginServiceProvider = Provider((ref) => LoginService());

class AsyncLoginNotifier extends AsyncNotifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {"token": ''};
  }

  Future<void> loginUser(String email, String password) async {
    final loginService = ref.read(loginServiceProvider);
    state = AsyncLoading();
    try {
      final response = await loginService.login(email, password);
      state = AsyncValue.data(response!);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
