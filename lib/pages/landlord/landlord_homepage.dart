import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/provider/page_provider.dart';
import 'package:kodisha_flutter/screens/landlord/estates_page.dart';
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
      appBar: TopNavBar(title: "Landlord HomePage"),
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
    );
  }
}
