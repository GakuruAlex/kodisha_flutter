import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/provider/page_provider.dart';
import 'package:kodisha_flutter/pages/landlord/estates_page.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/form/new_estate_form.dart';
import 'package:kodisha_flutter/widgets/navigation/bottom_navigation.dart';
import 'package:kodisha_flutter/widgets/navigation/destination_item.dart';
import 'package:kodisha_flutter/widgets/navigation/top_nav_bar.dart';

class LandlordHomepage extends ConsumerWidget {
  const LandlordHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageProvider);
    ref.listen<int>(pageProvider, (previous, next) {
      if (next == 0) {
        ref.read(estatesProvider.notifier).landlordEstates();
      }
    });

    return Scaffold(
      appBar: TopNavBar(title: "Landlord"),
      body: [EstatesPage(), EstatesPage()][page],
      bottomNavigationBar: BottomNavigation(
        destinationsWidgets: [
          DestinationItem(
            destinationIcon: Icons.home,
            destinationLabel: "Home",
          ),
          DestinationItem(
            destinationIcon: Icons.people,
            destinationLabel: "Tenants",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorsScheme.onPrimary,

        label: Text(
          "Add estate",
          style: TextStyle(fontSize: 24, color: colorsScheme.primary),
        ),
        onPressed: () {
          showModalBottomSheet(
            useSafeArea: true,
            backgroundColor: colorsScheme.onSecondary.withValues(alpha: .65),

            elevation: 20.0,
            context: context,
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: NewEstateForm(),
            ),
          );
        },
        icon: Icon(Icons.real_estate_agent, color: colorsScheme.primary),
      ),
    );
  }
}
