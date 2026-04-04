import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/admin/users_provider.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/form/user_form.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.userId});
  final int userId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDetailProvider(userId));
    return Scaffold(
      appBar: AppBar(title: Text(user!.firstname!)),
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.90,
          width: MediaQuery.sizeOf(context).width * .98,
          decoration: loginContainerDecoration,
          child: Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${user.firstname} ${user.lastname}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${user.emailAddress!}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: ${user.phonenumber}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 60),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserForm(type: "Edit", id: userId),
                              ),
                            );
                          },
                          tileColor: Color.fromARGB(248, 8, 131, 121),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            side: BorderSide(color: Color(0xFF76C6F5)),
                          ),
                          leading: Icon(Icons.edit),
                          title: Text("Edit"),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ListTile(
                          onTap: () {},
                          tileColor: Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            side: BorderSide(color: Color(0xFF76C6F5)),
                          ),
                          leading: Icon(Icons.admin_panel_settings),
                          title: Text("Make Landlord"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
