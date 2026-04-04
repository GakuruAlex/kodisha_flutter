import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/pages/admin/homepage.dart';
import 'package:kodisha_flutter/pages/admin/landlord_page.dart';
import 'package:kodisha_flutter/provider/admin/users_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/screens/landlord/tenants_page.dart';
import 'package:kodisha_flutter/provider/page_provider.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/screens/new_user.dart';
import 'package:kodisha_flutter/widgets/navigation/bottom_navigation.dart';
import 'package:kodisha_flutter/widgets/navigation/destination_item.dart';

class KodishaHomepage extends ConsumerWidget {
  const KodishaHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageProvider);
    ref.listen<int>(pageProvider, (previous, next) {
      if (next == 1) {
        ref.read(userNotifier.notifier).getLandlords();
      }
      if (next == 0) {
        ref.read(userNotifier.notifier).getUsers();
      }
    });

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
                onTap: () {
                  ref.invalidate(loginServiceProvider);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => Login()),
                  );
                },
              ),
            ),
          ],
        ),

        body: [HomePage(), LandlordPage(), TenantsPage()][currentPage],
        bottomNavigationBar: BottomNavigation(
          destinationsWidgets: [
            DestinationItem(
              destinationIcon: Icons.home,
              destinationLabel: "Home",
            ),
            DestinationItem(
              destinationIcon: Icons.work,
              destinationLabel: "Landlords",
            ),
            DestinationItem(
              destinationIcon: Icons.house,
              destinationLabel: "Tenants",
            ),
          ],
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
