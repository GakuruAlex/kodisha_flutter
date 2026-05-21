import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';
import 'form_inputs.dart';

void runAction(ActionInput action, WidgetRef ref) {
  switch (action) {
    case LoginInput(:String email, :String password):
      ref.read(loginNotifier.notifier).loginUser(email, password);
      break;

    case NewEstateInput(:String name, :String location, :XFile? image):
      ref.read(estatesProvider.notifier).addEstate({
        "name": name,
        "location": location,
        "image": image,
      });
      break;

    case CreateHouseInput(
      :String houseName,
      :int estateId,
      :List<XFile>? images,
      :IsOccupied isAvailable,
      :HouseType houseType,
      :List<UtilityModel>? utilities,
    ):
      final List<Map<String, dynamic>> utilitiesAttributes = utilities?.map((u) {
            return {
              "name": u.name?.dbValue ?? AccountName.wateraccount.dbValue,
              "meter_no": u.meterNumber ?? "",
              "last_reading": u.lastReading ?? 0,
            };
          }).toList() ?? [];

      final Map<String, dynamic> payload = {
        "house": {
          "house_name": houseName,
          "house_type": houseType.dbValue,
          "is_occupied": isAvailable.dbValue,
          "images": images,
          "utilities_attributes": utilitiesAttributes,
        },
      };

      ref.read(
        housesNotifierProvider((estateId: estateId, houseId: null)).notifier,
      ).addHouse(payload);
      break;

    case FormSubmitInput(:String formType, :Map<String, dynamic> payload, :int? id):
      if (formType.contains("estate")) {
        // Ready for update implementation
      } else if (formType.contains("house")) {
        // Ready for update implementation
      }
      break;
  }
}