import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/user_model.dart';
import 'package:kodisha_flutter/provider/admin/users_provider.dart';
import 'package:kodisha_flutter/screens/user_detail_screen.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class UserListItemCard extends ConsumerWidget {
  const UserListItemCard({super.key, required this.user});

  final User user;
  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Delete User"),
        content: Text("Do you accept ?"),
        elevation: 24,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Yes", style: Theme.of(context).textTheme.titleSmall),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancel",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifierProvider = ref.read(userNotifier.notifier);
    return Card(
      elevation: 10,
      shadowColor: colorsScheme.tertiary,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return UserDetailScreen(userId: user.id!);
              },
            ),
          );
        },
        splashColor: colorsScheme.onSurface,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ' ${user.firstname}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ' ${user.lastname} ',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  _showDeleteDialog(context).then((onValue) {
                    if (onValue) {
                      userNotifierProvider.deleteUser(user.id!);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("User Deleted!")));
                    }
                  });
                },
                icon: Icon(
                  Icons.delete_forever,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
