import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/house_model.dart';
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
final houseValueProvider =
    Provider.family<House?, ({int estateId, int houseId})>((ref, params) {
      return ref.watch(houseNotifierProvider(params)).value;
    });

// 🔄 3. Individual House State Engine
// 🔑 Use HouseNotifier.new to pass the parameter Record into the constructor
final houseNotifierProvider =
    AsyncNotifierProvider.family<
      HouseNotifier,
      House,
      ({int houseId, int estateId})
    >(HouseNotifier.new);

class HouseNotifier extends AsyncNotifier<House> {
  HouseNotifier(this.arg);
  final ({int houseId, int estateId}) arg;

  @override
  FutureOr<House> build() async {
    final response = await ref
        .read(housesServiceProvider)
        .getHouse(arg.estateId, arg.houseId);
    return House.fromJson(response.data);
  }

  Future<void> refreshHouse() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await ref
          .read(housesServiceProvider)
          .getHouse(arg.estateId, arg.houseId);
      return House.fromJson(response.data);
    });
  }
}

// 🗂️ 4. Houses List Collection State Engine
final housesNotifierProvider =
    AsyncNotifierProvider.family<
      HousesNotifier,
      List<House>,
      ({int? estateId, int? houseId})
    >(HousesNotifier.new);

class HousesNotifier extends AsyncNotifier<List<House>> {
  HousesNotifier(this.arg);
  final ({int? estateId, int? houseId}) arg;

  @override
  FutureOr<List<House>> build() async {
    if (arg.estateId == null) return [];

    final response = await ref
        .read(housesServiceProvider)
        .getHouses(arg.estateId!);
    final List<dynamic> data = response.data;
    return data.map((house) => House.fromJson(house)).toList();
  }

  Future<void> addHouse(Map<String, dynamic> houseData) async {
    if (arg.estateId == null) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await ref
          .read(estateServiceProvider)
          .postHouse(data: houseData, estateId: arg.estateId!);

      if (response.statusCode != 201) {
        throw Exception("Failed to add house.");
      }

      ref
          .read(estatesProvider.notifier)
          .updateEstateHousesNumber(id: arg.estateId!);
      ref.invalidate(estatesProvider);

      // Refreshes this specific family instance by execution of build() again
      ref.invalidateSelf();

      // Wait for the fresh network array fetch to complete and assign it
      return future;
    });
  }
}
