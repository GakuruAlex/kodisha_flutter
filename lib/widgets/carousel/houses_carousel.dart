import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/widgets/cards/generic_card.dart';
import 'package:kodisha_flutter/widgets/carousel/reusable_carousel.dart';

class HouseCarousel extends ConsumerWidget {
  const HouseCarousel({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final housesAsync = ref.watch(
      housesNotifierProvider((estateId: id, houseId: null)),
    );

    return housesAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),

      error: (error, stackTrace) => Center(
        child: Text(
          'Failed to load houses',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),

      data: (houses) {
        return ReusableCarousel<House>(
          items: houses,
          itemBuilder: (context, house, index) {
            return GenericCard<House>(
              id: house.id!,
              initialData: house,
              provider: houseValueProvider((
                estateId: id,
                houseId: house.id!,
              )),
              onTap: () {},
              onDelete: (index) async => 1,
              modelName: "House",
            );
          },
        );
      },
    );
  }
}