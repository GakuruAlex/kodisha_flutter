import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/screens/kodisha_homepage.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodisha',
      theme: kodishaTheme,
      home: const KodishaHomepage(),
    );
  }
}
