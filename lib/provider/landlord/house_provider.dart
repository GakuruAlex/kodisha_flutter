import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/estate_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/services/landlord/estate_service.dart';

final housesNotifierProvider =
    AsyncNotifierProvider.family<HouseNotifier, List<House>, ({int estateId, int houseId})>(
      (params) => HouseNotifier(params.estateId, params.houseId)  );
final estateServiceProvider = Provider((ref) => EstateService());


class HouseNotifier extends AsyncNotifier<List<House>> {
  HouseNotifier(this.estateId, this.houseId);
  int? estateId;
  int? houseId;
  @override
  List<House> build() {
    return getHouses();
  }

  List<House> getHouses() {
    final Estate currentEstate = ref.read(estateProvider(estateId!))!;

    return currentEstate.houses!.isNotEmpty ? currentEstate.houses! : [];
  }

  House getHouse() => state.value!.where((house)=> house.id == houseId).first;

  void addHouse(Map<String, dynamic> houseData) async {
    final previous = state.value ?? [];

    state = const AsyncLoading();

    final token = ref.read(loginNotifier).value;
    final estateService = ref.read(estateServiceProvider);

    try {
      final response = await estateService.postHouse(
        data: houseData,
        token: token!,
        estateId: estateId!,
      );

      if (response.statusCode == 201) {
        state = AsyncData([...previous, House.fromJson(response.data)]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
