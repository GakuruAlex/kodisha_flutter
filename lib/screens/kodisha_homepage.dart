import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/pages/homepage.dart';
import 'package:kodisha_flutter/pages/landlord_page.dart';
import 'package:kodisha_flutter/pages/tenants_page.dart';
import 'package:kodisha_flutter/provider/page_provider.dart';
import 'package:kodisha_flutter/screens/new_user.dart';
import 'package:kodisha_flutter/widgets/navigation/bottom_navigation.dart';
import 'package:kodisha_flutter/widgets/navigation/destination_item.dart';

class KodishaHomepage extends ConsumerWidget {
  const KodishaHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(pageProvider);

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
