import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/users_provider.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/user_list_item_card.dart';

class KodishaHomepage extends ConsumerWidget {
  const KodishaHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersProvider = ref.watch(userNotifier);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Kodisha"),
          actions: [
            SizedBox(
              width: 120,
              child: ListTile(
                tileColor: Theme.of(context).colorScheme.onSecondary,
                leading: Icon(Icons.logout),
                title: Text(
                  "Logout",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onTap: () {},
              ),
            ),
          ],
        ),

        body: Center(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.9,
            width: MediaQuery.sizeOf(context).width * 0.99,

            decoration: loginContainerDecoration,
            child: usersProvider.when(
              data: (data) => SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        UserListItemCard(user: data[index]),

                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 12),
                    itemCount: data.length,
                  ),
                ),
              ),
              error: (error, stack) => Center(
                child: Card(
                  child: Text(
                    '$error',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              loading: () => CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
