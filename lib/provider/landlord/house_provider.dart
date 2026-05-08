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
    Provider.family<House?, ({int estateId, int houseId})>(
  (ref, params) {
    return ref.watch(
      houseNotifierProvider(params),
    ).value;
  },
);
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
    final Estate currentEstate = ref.read(estateProvider(estateId!))!;

    return currentEstate.houses!.isNotEmpty ? currentEstate.houses! : [];
  }

  House getHouse() => state.value!.where((house) => house.id == houseId).first;

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
  } catch (error, stackTrace) {
    state = AsyncValue.error(error, stackTrace);
  }
}
}
