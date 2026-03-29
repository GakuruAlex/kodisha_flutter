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

  Future<void> addUser(Map<String, dynamic> userData) async {
    final token = ref.watch(loginNotifier);
    final user = User.fromJson(userData);
    state = AsyncLoading();

    try {
      final response = await ref
          .read(userService)
          .postUser(data: user.toJson([]), token: token.value!);
      state = AsyncValue.data([...state.value!, user.copywith(id: response)]);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> deleteUser(int id) async {
    state = AsyncLoading();

    final token = ref.watch(loginNotifier);
    final tempUsers = [...state.value!];

    final List<User> afterDelete = tempUsers
        .where((user) => user.id != id)
        .toList();

    try {
      final response = await ref
          .read(userService)
          .destroyUser(token: token.value!, id: id);
      state = AsyncValue.data(afterDelete);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  void updateUser(User updatedUser) {
    List<User> users = state.value!;
    state = AsyncData(
      users.map((user) {
        if (user.id == updatedUser.id) {
          return updatedUser; // replace the changed one
        }
        return user;
      }).toList(),
    );
  }
}

final userDetailProvider = Provider.family<User?, int>((ref, userId) {
  final users = ref.watch(userNotifier);
  List<User> currentUsers = users.value!;

  return currentUsers.where((user) => user.id == userId).first;
});
