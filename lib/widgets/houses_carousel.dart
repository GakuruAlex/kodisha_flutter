import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/widgets/cards/generic_card.dart';

class HouseCarousel extends ConsumerWidget {
  const HouseCarousel({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estate = ref.watch(estateProvider(id));
    final houses = estate?.houses ?? [];

    if (houses.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: houses.length,
        itemBuilder: (context, index, realIndex) {
          final house = houses[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GenericCard<House>(
              id: house.id!,
              provider: houseValueProvider(
                (estateId: id, houseId: house.id!),
              ),
              onTap: () {},
              onDelete: (index) async => 1,
              modelName: "House",
            ),
          );
        },
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.5,

          // enlarge current card
          enlargeCenterPage: true,

          // viewport fraction controls visible width
          viewportFraction: houses.length == 1 ? 0.9 : 0.75,

          enableInfiniteScroll: houses.length > 1,

          autoPlay: true,

          scrollDirection: Axis.horizontal,

          padEnds: true,
        ),
      ),
    );
  }
}