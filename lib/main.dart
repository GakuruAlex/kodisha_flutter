import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/pages/landlord_page.dart';
import 'package:kodisha_flutter/screens/landlord/tenants_page.dart';
import 'package:kodisha_flutter/screens/admin/kodisha_homepage.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

Future main() async {
  //debugPaintSizeEnabled = true;
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kodisha',
      theme: kodishaTheme,
      home: const Login(),
      routes: {
        '/home': (context) => KodishaHomepage(),
        '/landlords': (context) => const LandlordPage(),
        '/tenants': (context) => const TenantsPage(),
      },
    );
  }
}
