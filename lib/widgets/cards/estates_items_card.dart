import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/actions/actions.dart';
import 'package:kodisha_flutter/main.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/screens/details/estate_detail.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:transparent_image/transparent_image.dart';

class EstatesItemsCard extends ConsumerWidget {
  const EstatesItemsCard({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estate = ref.watch(estateProvider(id));
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => EstateDetail(id: id)));
        },
        splashColor: Theme.of(context).colorScheme.onPrimary,
        child: Stack(
          //clipBehavior: Clip.hardEdge,
          fit: StackFit.expand,
          children: [
            FadeInImage(
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(estate!.estateImage!),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                alignment: Alignment.topLeft,
                width: 40,
                height: 44,
                decoration: BoxDecoration(
                  color: colorsScheme.onError.withAlpha(150),
                ),
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 40,
                  color: colorsScheme.errorContainer,
                  onPressed: () {
                    showDeleteDialog(context, "Estate").then((onvalue) {
                      if (onvalue) {
                        final response = ref
                            .read(estatesProvider.notifier)
                            .deleteEstate(id: estate.id!);
                        response.then(
                          (response) => {
                            if (response == 200)
                              {
                                messengerKey.currentState?.showSnackBar(
                                  SnackBar(content: Text("Estate Deleted!")),
                                ),
                              },
                          },
                        );
                      }
                    });
                  },
                  icon: Icon(Icons.delete_forever),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                color: estate.vacancy!
                    ? colorsScheme.primary.withAlpha(170)
                    : colorsScheme.shadow,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name:",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(width: 8),
                        Text(
                          estate.name!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Location: ${estate.location!}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(width: 18),
                        Text(
                          "Houses: ${estate.numHouses!}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
