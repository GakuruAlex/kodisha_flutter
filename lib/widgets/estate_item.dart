import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/estate_model.dart';

class EstateItem extends StatelessWidget {
  const EstateItem({super.key, required this.estate});

  final Estate estate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [Text("Name"), SizedBox(width: 8), Text(estate.name!)],
        ),
      ),
    );
  }
}
