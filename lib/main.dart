import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodisha',
      theme: kodishaTheme,
      home: const Login(),
    );
  }
}
