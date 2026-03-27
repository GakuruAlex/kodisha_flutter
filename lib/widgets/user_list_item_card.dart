import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/user_model.dart';
import 'package:kodisha_flutter/screens/user_detail_screen.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class UserListItemCard extends ConsumerWidget {
  const UserListItemCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 10,
      shadowColor: colorsScheme.tertiary,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserDetailScreen(user: user),
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
            ],
          ),
        ),
      ),
    );
  }
}
