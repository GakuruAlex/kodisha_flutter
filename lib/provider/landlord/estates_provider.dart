import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/estate_model.dart';
import 'package:kodisha_flutter/services/landlord/landlord_service.dart';

final estatesProvider = AsyncNotifierProvider<EstatesNotifier, List<Estate>>(
  () => EstatesNotifier(),
);

class EstatesNotifier extends AsyncNotifier<List<Estate>> {
  @override
  FutureOr<List<Estate>> build() async {
    return await landlordEstates();
  }

  Future<List<Estate>> landlordEstates() async {
    final response = await ref.read(landlordServiceProvider).getEstates();
    final List<dynamic> data = response.data;
    return data.map<Estate>((d) => Estate.fromJson(d)).toList();
  }

  void addEstate(Map<String, dynamic> estateData) async {
    //debugPrint("Adding estate with data: $estateData");
    final previousState = state.value ?? [];
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final estateDataMap = estateData["estate"] ?? {};

      final XFile? imageFile = estateDataMap["image"];
      final Map<String, dynamic> formDataMap = {
        "estate[name]": estateDataMap["name"],
        "estate[location]": estateDataMap["location"],
      };

      if (imageFile != null) {
        formDataMap["estate[image]"] = await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        );
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await ref
          .read(landlordServiceProvider)
          .postNewEstate(data: formData);
      final Map<String, dynamic> resData = response.data;

      if(response.statusCode == 201){
        final newEstate = Estate(
        id: resData["id"],
        name: resData["name"],
        location: resData["location"],
        numHouses: resData["houses_count"] ?? 0,
        vacancy: resData["has_vacancy"] ?? false,
        estateImage: resData["image"],
      );
        return [...previousState, newEstate];
      } else {
        throw Exception("Failed to add estate. Status code: ${response.statusCode}");
      }

      
    });
  }

  Future<int> deleteEstate({required int id}) async {
    try {
      final response = await ref
          .read(landlordServiceProvider)
          .deleteEstate(estateID: id);

      if (response.statusCode == 200) {
        state = AsyncData(
          state.value!.where((estate) => estate.id != id).toList(),
        );
      }
      return response.statusCode ?? 400;
    } catch (error) {
      return 403;
    }
  }

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

final estateProvider = Provider.family<Estate?, int>((ref, estateId) {
  final estatesAsync = ref.watch(estatesProvider);

  final list = estatesAsync.value;
  if (list == null) return null;

  final index = list.indexWhere((estate) => estate.id == estateId);

  return index != -1 ? list[index] : null;
});
