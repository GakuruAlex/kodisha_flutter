import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/user_model.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/services/user_service.dart';

final userNotifier = AsyncNotifierProvider<AsyncUserNotifier, List<User>>(
  () => AsyncUserNotifier(),
);

final userService = Provider((_) => UserService());

class AsyncUserNotifier extends AsyncNotifier<List<User>> {
  @override
  List<User> build() {
    getUsers();
    return [];
  }

  Future<void> getUsers() async {
    state = AsyncLoading();
    final token = ref.watch(loginNotifier);

    try {
      final usersMap = await ref.read(userService).fetchUsers(token.value!);
      if (usersMap.isNotEmpty) {
        state = AsyncValue.data(
          usersMap.map((user) => User.fromJson(user)).toList(),
        );
      }
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}
