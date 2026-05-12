import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/screens/details/estate_detail.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/cards/generic_card.dart';

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
                    itemBuilder: (context, index) => GenericCard(
                      id: data[index].id!,
                      provider: estateProvider(data[index].id!),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EstateDetail(id: data[index].id!),
                          ),
                        );
                      },
                      onDelete: (id) {
                        return ref
                            .read(estatesProvider.notifier)
                            .deleteEstate(id: id);
                      },
                      modelName: "Estate",
                    ),
                    //EstatesItemsCard(id: data[index].id!),
                  ),
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bug_report,
                          color: Colors.red[400],
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Error Details",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),

                    const Divider(),

                    // Expanded ensures the scroll area takes up the available middle space
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            "$error\n\n$stack",
                            style: TextStyle(
                              fontFamily:
                                  'monospace', // Makes stack traces much easier to read
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Fixed button at the bottom
                    ElevatedButton.icon(
                      onPressed: () => ref.invalidate(estatesProvider),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        "Try Again",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
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
