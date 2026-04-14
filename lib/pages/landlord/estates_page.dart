import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
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
                      childAspectRatio: 2.5,
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
                      "$error",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(estatesProvider);
                      },
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: ListTile(
                          leading: Icon(Icons.refresh_outlined),
                          title: Text("Refresh"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => CircularProgressIndicator(),
            ),
          );
  }
}
