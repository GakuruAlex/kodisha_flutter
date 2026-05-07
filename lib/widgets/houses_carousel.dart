import 'package:flutter/material.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/widgets/cards/generic_card.dart';

class HouseCarousel extends StatelessWidget {
  const HouseCarousel({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context) {
    //final houseP = ref.watch(placeholderProvider<House>(widget.houses[0]));

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .5,
      child: CarouselView.builder(
        itemExtent: 300,
        itemBuilder: (BuildContext context, int index) => GenericCard<House>(
          id: index,
          provider: placeholderProvider(id),
          onTap: () {},
          onDelete: (index) async {
            return 1;
          },
          modelName: "House",
        ),
      ),
    );
  }
}
