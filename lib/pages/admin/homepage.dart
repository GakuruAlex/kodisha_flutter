import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/admin/users_provider.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/cards/user_list_item_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersProvider = ref.watch(userNotifier);

    return Container(
      padding: EdgeInsets.only(top: 20),
      height: MediaQuery.sizeOf(context).height * 0.87,
      width: MediaQuery.sizeOf(context).width,

      decoration: loginContainerDecoration,
      child: usersProvider.when(
        data: (data) => SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2,
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (BuildContext context, int index) =>
                  UserListItemCard(user: data[index]),
            ),
          ),
        ),
        error: (error, stack) => Center(
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$error', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  onPressed: () {
                    ref.invalidate(userNotifier);
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
