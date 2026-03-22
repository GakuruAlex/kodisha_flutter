import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/user_model.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class UserListItemCard extends ConsumerWidget {
  const UserListItemCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {},
      splashColor: colorsScheme.onSurface,
      child: Card(
        elevation: 10,
        shadowColor: colorsScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Center(
                      child: Text(
                        '${user.id}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'FirstName : ${user.firstname}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lastname: ${user.lastname} ',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              Text(
                'Email: ${user.emailAddress}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
