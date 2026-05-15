import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/form_model.dart';

class InfoOverlay extends StatelessWidget {
  final FormModel item;
  const InfoOverlay({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      // ignore: deprecated_member_use
      color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(220),
                ),
                // style: const TextStyle(
                //   fontWeight: FontWeight.bold,
                //   color: Colors.white,
                //),
              ),
              SizedBox(width: 8),
              Text(
                item.subTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withAlpha(220),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Wrap(
            spacing: 10,
            children: item.metaData().entries.map((e) {
              return Text(
                "${e.key}: ${e.value}",
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
