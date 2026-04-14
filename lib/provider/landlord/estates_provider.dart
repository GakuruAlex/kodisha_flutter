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
  List<Estate> build() {
    landlordEstates();
    return [];
  }

  Future<void> landlordEstates() async {
    final userService = ref.read(landlordServiceProvider);
    final token = ref.watch(loginNotifier).value!;
    state = AsyncLoading();
    try {
      final response = await userService.getEstates(token);
      //print(response);
      state = AsyncValue.data(response.map((d) => Estate.fromJson(d)).toList());
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  void addEstate(Map<String, dynamic> estateData) async {
    final token = ref.watch(loginNotifier).value!;
    final userService = ref.read(landlordServiceProvider);

    final currentState = state.value;
    state = AsyncLoading();
    final Estate newEstate = Estate(
      location: estateData["location"],
      name: estateData["name"],
    );
    try {
      final response = await userService.postNewEstate(
        token: token,
        data: newEstate.toJson(),
      );

      if (response.statusCode == 201) {
        state = AsyncData([
          ...currentState!,
          newEstate.copywith(
            id: response.data["id"],
            numHouses: response.data["houses_count"],
            vacancy: response.data["has_vacancy"],
            //houses: response.data["houses"],
          ),
        ]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<int> deleteEstate({required int id}) async {
    state = AsyncLoading();
    final token = ref.watch(loginNotifier).value;
    final landlordService = ref.watch(landlordServiceProvider);
    try {
      final response = await landlordService.deleteEstate(
        token: token!,
        estateID: id,
      );

      if (response.statusCode == 200) {
        final currentState = state.value;

        final afterDeleteState = currentState!
            .where((estate) => estate.id != id)
            .toList();
        state = AsyncData(afterDeleteState);
      }
      return response.statusCode!;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return 403;
    }
  }

  void updateEstateHousesNumber({required int id}) {
    state = AsyncLoading();

    try {
      final estate = state.value!.where((estate) => estate.id == id).first;
      int numHouses = estate.numHouses!;
      state = AsyncData([
        ...state.value!.map((st) {
          if (st.id == id) {
            return st.copywith(numHouses: numHouses + 1);
          }
          return st;
        }),
      ]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final estateProvider = Provider.family<Estate?, int>((ref, estateId) {
  final estates = ref.watch(estatesProvider);

  final estate = estates.value!.where((estate) => estate.id == estateId);
  if (estate.isEmpty) {
    return null;
  }
  return estate.first;
});
