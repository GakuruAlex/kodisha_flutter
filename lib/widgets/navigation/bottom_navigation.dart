import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/page_provider.dart';
import 'package:kodisha_flutter/provider/users_provider.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key, required this.destinationsWidgets});

  final List<Widget> destinationsWidgets;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageProvider);
    ref.listen<int>(pageProvider, (previous, next) {
      if (next == 1) {
        ref.read(userNotifier.notifier).getLandlords();
      }
      if (next == 0) {
        ref.read(userNotifier.notifier).getUsers();
      }
    });

    return NavigationBar(
      selectedIndex: page,
      onDestinationSelected: (value) {
        ref.read(pageProvider.notifier).state = value;
      },
      destinations: destinationsWidgets,
    );
  }
}
