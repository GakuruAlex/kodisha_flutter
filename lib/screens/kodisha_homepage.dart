import 'package:flutter/material.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class KodishaHomepage extends StatelessWidget {
  const KodishaHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kodisha")),
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * .9,
          width: MediaQuery.sizeOf(context).width,

          decoration: pagesDecoration,
          child: Text(
            "Hello Kodisha",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
