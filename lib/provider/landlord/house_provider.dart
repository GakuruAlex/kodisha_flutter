import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/estate_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/services/landlord/estate_service.dart';

final housesNotifierProvider =
    AsyncNotifierProvider.family<HouseNotifier, List<House>, int>(
      (estateId) => HouseNotifier(estateId),
    );
final estateServiceProvider = Provider((ref) => EstateService());

class HouseNotifier extends AsyncNotifier<List<House>> {
  HouseNotifier(this.estateId);
  int estateId;
  @override
  List<House> build() {
    return getHouses(estateId);
  }

  List<House> getHouses(int estateId) {
    final Estate currentEstate = ref.read(estateProvider(estateId))!;

    return currentEstate.houses!.isNotEmpty ? currentEstate.houses! : [];
  }

  void addHouse(House house) async {
    state = AsyncLoading();
    final Estate currentEstate = ref.read(estateProvider(estateId))!;

    final token = ref.watch(loginNotifier).value;
    final estateService = ref.read(estateServiceProvider);
    try {
      final response = await estateService.postHouse(
        data: house.toJson(),
        token: token!,
        estateId: estateId,
      );
      //print("Response is: $response");

      if (response.statusCode! == 201) {
        state = AsyncData([...state.value!, House.fromJson(response.data)]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
