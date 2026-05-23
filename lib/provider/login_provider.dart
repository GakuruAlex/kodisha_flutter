import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/services/login_service.dart';
import 'package:kodisha_flutter/services/api_client.dart'; // Ensure this points to your global dioProvider file

// 🔐 Authentication State Holder
class AuthState {
  final String? token;
  final String role;

  const AuthState({this.token, this.role = ""});

  bool get isAuthenticated => token != null && token!.isNotEmpty;
}

// 👑 Role-Based Access Control States
enum AuthRoleState { loggedOut, admin, member, unknown }

// 🎯 Reactive UI Role Listener
final authRoleProvider = Provider<AuthRoleState>((ref) {
  final authAsync = ref.watch(loginNotifier);

  // Fallback to logged out state if loading, erroring, or lacking active data
  if (authAsync.isLoading || authAsync.hasError || !authAsync.hasValue) {
    return AuthRoleState.loggedOut;
  }

  final authState = authAsync.value!;
  if (!authState.isAuthenticated) return AuthRoleState.loggedOut;

  switch (authState.role.toLowerCase()) {
    case 'admin':
      return AuthRoleState.admin;
    case 'member':
      return AuthRoleState.member;
    default:
      return AuthRoleState.unknown;
  }
});

// 🔄 Global Login State Engine
final loginNotifier = AsyncNotifierProvider<AsyncLoginNotifier, AuthState>(
  () => AsyncLoginNotifier(),
);

// 📦 Inject the global shared Dio instance into LoginService
final loginServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return LoginService(dio);
});

class AsyncLoginNotifier extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() {
    // Initializes your application in an unauthenticated baseline state
    return const AuthState();
  }

  Future<void> loginUser(String email, String password) async {
    state = const AsyncLoading();

    // AsyncValue.guard automatically wraps execution, traps errors, and pipes them into AsyncError
    state = await AsyncValue.guard(() async {
      final responseMap = await ref.read(loginServiceProvider).login(email, password);

      if (!responseMap.containsKey("token")) {
        throw Exception("Invalid response structure from server");
      }

      final token = responseMap["token"];
      final role = responseMap["user"]?["role"] ?? "";

      return AuthState(token: token, role: role);
    });
  }

  /// Triggers cache clearing and drops authentication state down to baseline values.
  /// This is safely invoked automatically by your dioProvider's onError interceptor on 401s!
  void logout() {
    state = const AsyncValue.data(AuthState());
  }
}