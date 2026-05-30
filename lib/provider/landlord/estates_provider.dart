import 'dart:async';
import 'package:dio/dio.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/estate_model.dart';
import 'package:kodisha_flutter/services/landlord/landlord_service.dart';

final estatesProvider = AsyncNotifierProvider<EstatesNotifier, List<Estate>>(
  () => EstatesNotifier(),
);

Future<FormData> _buildFormData(Map<String, dynamic> estateData) async {
  final estateFields = estateData["estate"] ?? estateData;
  final dynamic imagePayload = estateFields["image"];

  final Map<String, dynamic> wrappedPayload = {
    "estate[name]": estateFields["name"],
    "estate[location]": estateFields["location"],
  };

  if (imagePayload is XFile) {
    //debugPrint("Building form data with local image file.");
    wrappedPayload["estate[image]"] = await MultipartFile.fromFile(
      imagePayload.path,
      filename: imagePayload.name,
    );
  } else {
    //debugPrint(
    //  "Image payload is a remote URL string or null; skipping file attachment.",
    //);
  }

  return FormData.fromMap(wrappedPayload);
}

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
    final previousState = state.value ?? [];
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final formData = await _buildFormData(estateData);

      final response = await ref
          .read(landlordServiceProvider)
          .postNewEstate(data: formData);

      if (response.statusCode == 201) {
        final newEstate = Estate.fromJson(
          response.data as Map<String, dynamic>,
        );
        return [...previousState, newEstate];
      } else {
        throw Exception(
          "Failed to add estate. Status code: ${response.statusCode}",
        );
      }
    });
  }

  void updateEstate({
    required int estateID,
    required Map<String, dynamic> estateData,
  }) async {
    final previousState = state.value ?? [];
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final formData = await _buildFormData(estateData);
      //debugPrint(
        //"FormData for update: ${formData.fields} with files: ${formData.files}",
     // );

      final response = await ref
          .read(landlordServiceProvider)
          .updateEstate(data: formData, estateID: estateID);

      if (response.statusCode == 200) {
        //debugPrint(
          //"Estate updated successfully. Response data: ${response.data}",
       // );
        final updatedEstate = Estate.fromJson(
          response.data as Map<String, dynamic>,
        );
        return [
          for (final estate in previousState)
            if (estate.id == estateID) updatedEstate else estate,
        ];
      } else {
        throw Exception(
          "Failed to update estate. Status code: ${response.statusCode}",
        );
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
          estate.copyWith(numHouses: (estate.numHouses ?? 0) + 1)
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
