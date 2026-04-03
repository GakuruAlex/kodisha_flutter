import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';

class EstatesItemsCard extends ConsumerWidget {
  const EstatesItemsCard({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estate = ref.watch(estateProvider(id));
    return Card(
      elevation: 20,
      shadowColor: Theme.of(context).colorScheme.inversePrimary,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Name:",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(width: 8),
                    Text(
                      estate!.name!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Text(
                      "Location:",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(width: 8),
                    Text(
                      estate.location!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Num of houses:",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "${estate.numHouses!}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      "Vacancy:",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(width: 8),
                    Text(
                      estate.vacancy! ? "Available" : "Unavailable",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
