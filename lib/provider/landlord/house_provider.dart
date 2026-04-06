import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/estate_provider.dart';

final housesNotifierProvider =
    NotifierProvider.family<HouseNotifier, List<House>, int>(
      (estateId) => HouseNotifier(estateId),
    );

class HouseNotifier extends Notifier<List<House>> {
  HouseNotifier(this.estateId);
  int estateId;
  @override
  List<House> build() {
    return getHouses(estateId);
  }

  List<House> getHouses(int estateId) {
    final currentEstate = ref.read(estateProvider(estateId));

    return currentEstate!.houses!.length > 1
        ? currentEstate.houses as List<House>
        : [];
  }

  void addHouse(House house) {
    state = [...state, house];
  }
}
