import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/cards/estates_items_card.dart';

class EstatesPage extends ConsumerWidget {
  const EstatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estates = ref.watch(estatesProvider);
    final content = Center(child: Text("No Estates yet. Add some!"));
    return estates.value!.isEmpty
        ? content
        : Container(
            decoration: loginContainerDecoration,
            child: estates.when(
              data: (data) => SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3,
                    ),
                    itemBuilder: (context, index) =>
                        EstatesItemsCard(id: data[index].id!),
                  ),
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$error $stack",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              loading: () => CircularProgressIndicator(),
            ),
          );
  }
}
