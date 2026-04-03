import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/page_provider.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key, required this.destinationsWidgets});

  final List<Widget> destinationsWidgets;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageProvider);

    return NavigationBar(
      selectedIndex: page,
      onDestinationSelected: (value) {
        ref.read(pageProvider.notifier).state = value;
      },
      destinations: destinationsWidgets,
    );
  }
}
