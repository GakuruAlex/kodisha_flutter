import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class TopNavBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopNavBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.labelSmall),
        leading: Icon(
          Icons.home,
          size: 32,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        actions: [
          SizedBox(
            width: 150,
            child: ListTile(
              tileColor: colorsScheme.errorContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                ref.invalidate(estateProvider);
                ref.invalidate(estateProvider);
                ref.invalidate(roleProvider);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
