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
      //print("Response in provider $response ${response.statusCode}");
      print("Response data: ${response}");
      state = AsyncValue.data(response.map((d) => Estate.fromJson(d)).toList());
    } catch (error, stack) {
      //print("Error in Provider $error");
      state = AsyncValue.error(error, stack);
    }
  }
}

final estateProvider = Provider.family<Estate?, int>((ref, estate_id) {
  final estates = ref.watch(estatesProvider);
  final List<Estate> estate_f = estates.value!;

  final estate = estates.value!.where((estate) => estate.id == estate_id);
  if (estate.isEmpty) {
    return null;
  }
  return estate.first;
});
