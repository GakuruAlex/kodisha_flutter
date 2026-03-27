import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/user_model.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.firstname!}')),
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
                    'Name: ${user.firstname}',
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
                          onTap: () {},
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
                          leading: Icon(Icons.delete),
                          title: Text("Delete"),
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
