import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/users_provider.dart';
import 'package:kodisha_flutter/screens/new_user.dart';
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
              width: 160,
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

        body: Container(
          padding: EdgeInsets.only(top: 20),
          height: MediaQuery.sizeOf(context).height * 0.84,
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
                child: Text(
                  '$error',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            loading: () => CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => NewUser()));
          },
          child: Icon(Icons.person_add_alt, color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}
