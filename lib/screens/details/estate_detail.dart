import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/screens/form/house/house_create.dart';
import 'package:kodisha_flutter/screens/login.dart';
import 'package:kodisha_flutter/theme/main_theme.dart';
import 'package:kodisha_flutter/widgets/cards/generic_card.dart';
import 'package:kodisha_flutter/widgets/carousel/houses_carousel.dart';
import 'package:kodisha_flutter/widgets/navigation/top_nav_bar.dart';

class EstateDetail extends ConsumerWidget {
  const EstateDetail({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estate = ref.watch(estateProvider(id));
    final houses = ref.watch(
      housesNotifierProvider((estateId: id, houseId: null)),
    );
    return Scaffold(
      appBar: TopNavBar(title: estate!.name!, isHome: false),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.sizeOf(context).width * .99,
          height: MediaQuery.of(context).size.height * .95,
          decoration: loginContainerDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Card(
              //   color: estate.vacancy!
              //       ? colorsScheme.primary
              //       : colorsScheme.errorContainer,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Row(
              //           children: [Text("Location:"), Text(estate.location!)],
              //         ),
              //         Row(
              //           children: [
              //             Text("Number of Houses: "),
              //             Text("${estate.numHouses}"),
              //           ],
              //         ),
              //         Row(
              //           children: [
              //             Text("Vacancy: "),
              //             Text("${estate.vacancy}"),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .4,
                child: GenericCard(
                  id: id,
                  provider: estateProvider(id),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => EstateDetail(id: data[index].id!),
                    //   ),
                    // );
                  },
                  onDelete: (id) {
                    return ref
                        .read(estatesProvider.notifier)
                        .deleteEstate(id: id);
                  },
                  modelName: "Estate",
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .43,
                    width: MediaQuery.sizeOf(context).width,
                    child: houses.when(
                      data: (data) => data.isNotEmpty
                          // ? ListView.builder(
                          //     itemCount: data.length,
                          //     itemBuilder: (BuildContext context, index) {
                          //       return Text("House No: ${data[index].name}");
                          //     },
                          //   )
                          ? HouseCarousel(id: id)
                          : Text("No Houses yet."),

                      error: (error, stackTrace) {
                        final errorString = error.toString().toLowerCase();
                        final bool isUnauthorized =
                            errorString.contains("unauthorized") ||
                            errorString.contains("401");

                        if (isUnauthorized) {
                          Future.microtask(() {
                            ref.invalidate(loginNotifier);

                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                                (route) =>
                                    false, // This removes all previous routes
                              );
                            }
                          });
                        }

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              isUnauthorized
                                  ? "Session expired. Please login again."
                                  : "$error",
                              style: TextStyle(color: colorsScheme.error),
                            ),
                          ),
                        );
                      },
                      loading: () => Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => HouseFormPage(estateId: id)),
          );
        },
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
