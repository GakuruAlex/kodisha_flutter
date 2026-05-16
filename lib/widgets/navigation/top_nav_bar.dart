import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class TopNavBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopNavBar({super.key, required this.title, this.isHome = false});
  final String title;
  final bool isHome;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      // 1. Force the background to be visible against the body gradient
      backgroundColor: colorsScheme.primary,
      elevation: 4, // Add a slight shadow to separate it from the body
      // 2. Ensure the title stands out
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.white, // Explicitly white for visibility
        ),
      ),
      centerTitle: true,

      // 3. Leading Icon
      leading: isHome
          ? Icon(Icons.house, color: colorsScheme.onPrimary)
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),

      actions: [
        if (isHome)
          IconButton(
            icon: const Icon(Icons.logout),
            color: colorsScheme.error, // Your red color (0xFFDD0404)
            onPressed: () {
              ref.invalidate(estateProvider);
              ref.read(loginNotifier.notifier).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
