import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/estate_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/services/landlord/estate_service.dart';

final housesNotifierProvider =
    AsyncNotifierProvider.family<
      HousesNotifier,
      List<House>,
      ({int? estateId, int? houseId})
    >((params) => HousesNotifier(params.estateId, params.houseId));
final estateServiceProvider = Provider((ref) => EstateService());
final houseValueProvider =
    Provider.family<House?, ({int estateId, int houseId})>((ref, params) {
      return ref.watch(houseNotifierProvider(params)).value;
    });
final houseNotifierProvider =
    AsyncNotifierProvider.family<
      HouseNotifier,
      House,
      ({int houseId, int estateId})
    >((params) => HouseNotifier(params.houseId, params.estateId));

class HouseNotifier extends AsyncNotifier<House> {
  HouseNotifier(this.houseId, this.estateId);
  final int houseId;
  final int estateId;
  @override
  FutureOr<House> build() {
    return getHouse();
  }

  House getHouse() {
    final Estate houseEstate = ref.read(estateProvider(estateId))!;

    return houseEstate.houses!.where((house) => house.id == houseId).first;
  }
}

class HousesNotifier extends AsyncNotifier<List<House>> {
  HousesNotifier(this.estateId, this.houseId);
  int? estateId;
  int? houseId;
  @override
  List<House> build() {
    return getHouses();
  }

  List<House> getHouses() {
    final Estate currentEstate = ref.watch(estateProvider(estateId!))!;

    return currentEstate.houses!.isNotEmpty ? currentEstate.houses! : [];
  }

  House getHouse() => state.value!.where((house) => house.id == houseId).first;
  Future<void> addHouse(Map<String, dynamic> houseData) async {
    // 1. Optional: Set state to loading if you want a spinner
    state = const AsyncLoading();
    final estateService = ref.read(estateServiceProvider);
    final token = ref.read(loginNotifier).value;
    //final previous = state.value ?? [];

    try {
      final response = await estateService.postHouse(
        token: token!,
        data: houseData,
        estateId: estateId!,
      );

      if (response.statusCode == 201) {
        // 2. Update the parent estate count
        ref
            .read(estatesProvider.notifier)
            .updateEstateHousesNumber(id: estateId!);

        // 3. REFRESH THE DATA
        // This forces the provider to re-run its build() method and fetch the latest list
        ref.invalidateSelf();

        // 4. Wait for the refresh to complete before the UI thinks we're "done"
        await future;
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
