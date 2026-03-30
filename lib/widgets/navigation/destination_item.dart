import 'package:flutter/material.dart';

class DestinationItem extends StatelessWidget {
  const DestinationItem({
    super.key,
    required this.destinationIcon,
    required this.destinationLabel,
  });

  final IconData destinationIcon;
  final String destinationLabel;

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: Icon(destinationIcon),
      label: destinationLabel,
    );
  }
}
