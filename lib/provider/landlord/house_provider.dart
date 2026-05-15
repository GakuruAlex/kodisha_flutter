import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'package:kodisha_flutter/services/landlord/estate_service.dart';
import 'package:kodisha_flutter/services/landlord/house_service.dart';

final housesNotifierProvider =
    AsyncNotifierProvider.family<
      HousesNotifier,
      List<House>,
      ({int? estateId, int? houseId})
    >((params) => HousesNotifier(params.estateId, params.houseId));
final estateServiceProvider = Provider((ref) => EstateService());
final housesServiceProvider = Provider((ref) => HouseService());
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
  FutureOr<House> build() async {
    await getHouse();
    return state.value!;
  }

  Future<void> getHouse() async {
    final housesServices = ref.read(housesServiceProvider);
    final token = ref.watch(loginNotifier).value!;

    state = const AsyncLoading();

    try {
      final response = await housesServices.getHouse(token, estateId, houseId);
      if (response.statusCode == 200) {
        state = AsyncData(House.fromJson(response.data));
      } else {
        state = AsyncValue.error(
          response.data?.error,
          StackTrace.fromString("Error"),
        );
      }
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}

class HousesNotifier extends AsyncNotifier<List<House>> {
  HousesNotifier(this.estateId, this.houseId);
  int? estateId;
  int? houseId;
  @override
  FutureOr<List<House>> build() async {
    final housesServices = ref.read(housesServiceProvider);
    final token = ref.watch(loginNotifier).value;

    if (token == null) return [];

    final response = await housesServices.getHouses(token, estateId!);

    if (response.statusCode == 200) {
      //print("HOUSE DATA FROM DB: $response.data");
      final List<dynamic> data = response.data;
      return data.map((house) => House.fromJson(house)).toList();
    } else {
      throw Exception("Failed to load houses");
    }
  }

  Future<void> addHouse(Map<String, dynamic> houseData) async {
    state = const AsyncLoading();
    final estateService = ref.read(estateServiceProvider);
    final token = ref.read(loginNotifier).value;
    //print("HOUSE DATA: $houseData");

    try {
      final response = await estateService.postHouse(
        token: token!,
        data: houseData,
        estateId: estateId!,
      );

      if (response.statusCode == 201) {
        ref
            .read(estatesProvider.notifier)
            .updateEstateHousesNumber(id: estateId!);

        // Safely extract utilities returned from the backend response using a null-aware fallback check
        final List<dynamic>? rawUtilitiesJson =
            response.data["utilities"] as List<dynamic>?;
        final List<UtilityModel> parsedUtilities =
            rawUtilitiesJson
                ?.map((u) => UtilityModel.fromJson(u as Map<String, dynamic>))
                .toList() ??
            [];

        state = AsyncData([
          ...state.value!,
          House(
            id: response.data["id"],
            houseType: HouseType.fromDbValue(houseData["house_type"]),
            isOccupied: IsOccupied.fromValues(houseData["is_occupied"]),
            name: houseData["name"],
            images: List<String>.from(response.data["images"] ?? []),
            utilities:
                parsedUtilities, // Directly binds the clean, structured data models
          ),
        ]);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
