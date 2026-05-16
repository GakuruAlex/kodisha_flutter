import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/services/login_service.dart';

class AuthState {
  final String? token;
  final String role;

  const AuthState({this.token, this.role = ""});

  bool get isAuthenticated => token != null && token!.isNotEmpty;
}

enum AuthRoleState { loggedOut, admin, member, unknown }

final authRoleProvider = Provider<AuthRoleState>((ref) {
  final authAsync = ref.watch(loginNotifier);

  if (authAsync.isLoading || authAsync.hasError || !authAsync.hasValue) {
    return AuthRoleState.loggedOut;
  }

  final authState = authAsync.value!;

  if (!authState.isAuthenticated) {
    return AuthRoleState.loggedOut;
  }

  if (authState.role == 'admin') return AuthRoleState.admin;
  if (authState.role == 'member') return AuthRoleState.member;
  return AuthRoleState.unknown;
});

final loginNotifier = AsyncNotifierProvider<AsyncLoginNotifier, AuthState>(
  () => AsyncLoginNotifier(),
);

final loginServiceProvider = Provider((ref) => LoginService());

class AsyncLoginNotifier extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() {
    return const AuthState();
  }

  Future<void> loginUser(String email, String password) async {
    final loginService = ref.read(loginServiceProvider);
    state = const AsyncLoading();

    try {
      final response = await loginService.login(email, password);

      if (response.containsKey("token")) {
        final token = response["token"];
        final role = response["user"]?["role"] ?? "";

        state = AsyncValue.data(AuthState(token: token, role: role));
      } else {
        throw Exception("Invalid response structure from server");
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void logout() {
    state = const AsyncValue.data(AuthState());
  }
}