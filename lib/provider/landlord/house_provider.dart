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

  void addHouse(Map<String,dynamic> houseData) async {
  final previous = state.value ?? [];

  state = const AsyncLoading();

  final token = ref.read(loginNotifier).value;
  final estateService = ref.read(estateServiceProvider);

  try {
    final response = await estateService.postHouse(
      data: houseData,
      token: token!,
      estateId: estateId,
    );

    if (response.statusCode == 201) {
      state = AsyncData([
        ...previous,
        House.fromJson(response.data),
      ]);
    }
  } catch (error, stackTrace) {
    state = AsyncValue.error(error, stackTrace);
  }
}
}
