import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/services/landlord/estate_service.dart';
import 'package:kodisha_flutter/services/landlord/house_service.dart';
import 'package:kodisha_flutter/services/api_client.dart'; // Assuming dioProvider lives here

// 📦 1. Services
final estateServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return EstateService(dio);
});

final housesServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return HouseService(dio);
});

// 🏘️ 2. Read-Only State Family Providers
final houseValueProvider = Provider.family<House?, ({int estateId, int houseId})>((ref, params) {
  return ref.watch(houseNotifierProvider(params)).value;
});

// 🔄 3. Individual House State Engine
// 🔑 Use HouseNotifier.new to pass the parameter Record into the constructor
final houseNotifierProvider = AsyncNotifierProvider.family<HouseNotifier, House, ({int houseId, int estateId})>(
  HouseNotifier.new,
);

class HouseNotifier extends AsyncNotifier<House> {
  HouseNotifier(this.arg);
  final ({int houseId, int estateId}) arg;

  @override
  FutureOr<House> build() async {
    final response = await ref.read(housesServiceProvider).getHouse(arg.estateId, arg.houseId);
    return House.fromJson(response.data);
  }

  Future<void> refreshHouse() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(housesServiceProvider).getHouse(arg.estateId, arg.houseId);
      return House.fromJson(response.data);
    });
  }
}

// 🗂️ 4. Houses List Collection State Engine
final housesNotifierProvider = AsyncNotifierProvider.family<HousesNotifier, List<House>, ({int? estateId, int? houseId})>(
  HousesNotifier.new,
);

class HousesNotifier extends AsyncNotifier<List<House>> {
  HousesNotifier(this.arg);
  final ({int? estateId, int? houseId}) arg;

  @override
  FutureOr<List<House>> build() async {
    if (arg.estateId == null) return [];
    
    final response = await ref.read(housesServiceProvider).getHouses(arg.estateId!);
    final List<dynamic> data = response.data;
    return data.map((house) => House.fromJson(house)).toList();
  }

  Future<void> addHouse(Map<String, dynamic> houseData) async {
    debugPrint("Arguments received for adding house: estateId=${arg.estateId}, houseId=${arg.houseId}");
    debugPrint("Adding house with data: $houseData");
    if (arg.estateId == null) return;
    
    final previousState = state.value ?? [];
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await ref.read(estateServiceProvider).postHouse(
            data: houseData,
            estateId: arg.estateId!,
          );

      ref.read(estatesProvider.notifier).updateEstateHousesNumber(id: arg.estateId!);

      final List<dynamic>? rawUtilitiesJson = response.data["utilities"] as List<dynamic>?;
      final List<UtilityModel> parsedUtilities = rawUtilitiesJson
              ?.map((u) => UtilityModel.fromJson(u as Map<String, dynamic>))
              .toList() ?? [];

      final Map<String, dynamic> houseFormValues = houseData["house"] ?? houseData;

      final newHouse = House(
        id: response.data["id"],
        houseType: HouseType.fromDbValue(houseFormValues["house_type"]),
        isOccupied: IsOccupied.fromValues(houseFormValues["is_occupied"]),
        name: houseFormValues["house_name"] ?? houseFormValues["name"],
        images: List<String>.from(response.data["images"] ?? []),
        utilities: parsedUtilities,
      );

      return [...previousState, newHouse];
    });
  }
}