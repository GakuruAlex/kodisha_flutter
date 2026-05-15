import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/estate_model.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/services/landlord/landlord_service.dart';

final landlordServiceProvider = Provider((_) => LandlordService());

final estatesProvider = AsyncNotifierProvider<EstatesNotifier, List<Estate>>(
  () => EstatesNotifier(),
);

class EstatesNotifier extends AsyncNotifier<List<Estate>> {
  @override
  FutureOr<List<Estate>> build() async {
    // build() should return the data directly for AsyncNotifier
    return await landlordEstates();
  }

  Future<List<Estate>> landlordEstates() async {
    final userService = ref.read(landlordServiceProvider);
    final token = ref.watch(loginNotifier).value;
    
    if (token == null) return [];

    final response = await userService.getEstates(token);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map<Estate>((d) => Estate.fromJson(d)).toList();
    } else {
      throw Exception("Failed to load estates");
    }
  }

  void addEstate(Map<String, dynamic> estateData) async {
    final token = ref.read(loginNotifier).value;
    final userService = ref.read(landlordServiceProvider);
    
    // Hold reference to previous state to append new item
    final previousState = state.value ?? [];
    state = const AsyncLoading();

    try {
      final response = await userService.postNewEstate(
        token: token!,
        data: estateData,
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> resData = response.data;
        
        final newEstate = Estate(
          id: resData["id"],
          name: resData["name"],
          location: resData["location"],
          numHouses: resData["houses_count"] ?? 0,
          vacancy: resData["has_vacancy"] ?? false,
          estateImage: resData["image"],
        );

        state = AsyncData([...previousState, newEstate]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<int> deleteEstate({required int id}) async {
    final token = ref.read(loginNotifier).value;
    final landlordService = ref.read(landlordServiceProvider);
    
    try {
      final response = await landlordService.deleteEstate(
        token: token!,
        estateID: id,
      );

      if (response.statusCode == 200) {
        state = AsyncData(
          state.value!.where((estate) => estate.id != id).toList()
        );
      }
      return response.statusCode ?? 400;
    } catch (error) {
      // Don't kill the whole list state if one delete fails, just return error code
      return 403;
    }
  }

  // Optimized: Increments the count without triggering a global loading spinner
  void updateEstateHousesNumber({required int id}) {
    if (!state.hasValue) return;

    state = AsyncData([
      for (final estate in state.value!)
        if (estate.id == id)
          estate.copywith(numHouses: (estate.numHouses ?? 0) + 1)
        else
          estate,
    ]);
  }
}

// family provider to get a specific estate by ID
final estateProvider = Provider.family<Estate?, int>((ref, estateId) {
  final estatesAsync = ref.watch(estatesProvider);
  return estatesAsync.value?.firstWhere(
    (estate) => estate.id == estateId,
    orElse: () => throw Exception("Estate not found"),
  );
});