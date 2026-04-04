import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';

class EstateDetail extends ConsumerWidget {
  const EstateDetail({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estate = ref.watch(estateProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          estate!.name!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .99,
          height: MediaQuery.of(context).size.height * .95,
          decoration: loginContainerDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: estate.vacancy!
                    ? colorsScheme.primary
                    : colorsScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [Text("Location:"), Text(estate.location!)],
                      ),
                      Row(
                        children: [
                          Text("Number of Houses: "),
                          Text("${estate.numHouses}"),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Vacancy: "),
                          Text("${estate.vacancy}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .4,
                    child: estate.houses!.isNotEmpty
                        ? ListView.builder(
                            itemCount: estate.houses!.length,
                            itemBuilder: (BuildContext context, index) {
                              return Text(
                                "House No: ${estate.houses![index].name}",
                              );
                            },
                          )
                        : Text("No Houses yet."),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          "Add a house",
          style: TextStyle(color: colorsScheme.onPrimary, fontSize: 24),
        ),
        icon: Icon(
          Icons.add_home_rounded,
          color: colorsScheme.onTertiary,
          size: 28,
        ),
      ),
    );
  }
}
