import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart'; // Added
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';

sealed class ActionInput {}

class LoginInput extends ActionInput {
  LoginInput({required this.email, required this.password});
  final String email;
  final String password;
}

class CreateHouseInput extends ActionInput {
  CreateHouseInput({
    required this.houseName,
    required this.estateId,
    required this.images,
    required this.houseType,
    required this.isAvailable,
    this.utilities, // Added to receive parsed inline utilities list
  });
  final String houseName;
  final IsOccupied isAvailable;
  final int estateId;
  final List<XFile>? images;
  final HouseType houseType;
  final List<UtilityModel>? utilities; // Added
}

class NewEstateInput extends ActionInput {
  NewEstateInput({required this.name, required this.location, this.image});
  final String location;
  final String name;
  final XFile? image;
}

void runAction(ActionInput action, WidgetRef ref) {
  switch (action) {
    case LoginInput(:String email, :String password):
      ref.read(loginNotifier.notifier).loginUser(email, password);
      break;
    case CreateHouseInput(
      :String houseName,
      :int estateId,
      :List<XFile>? images,
      :IsOccupied isAvailable,
      :HouseType houseType,
      :List<UtilityModel>? utilities,
    ):
      // 1. Map utilities to the 'attributes' format Rails requires
      final List<Map<String, dynamic>> utilitiesAttributes =
          utilities
              ?.map(
                (u) => {
                  "name": AccountName.toDbValue(u.title),
                  "meter_no": u.subTitle,
                  "last_reading":
                      int.tryParse(u.metaData()["last reading"] ?? "0") ?? 0,
                },
              )
              .toList() ??
          [];

      // 2. Wrap everything in a "house" key so Rails params[:house] isn't nil
      final Map<String, dynamic> payload = {
        "house": {
          "house_name": houseName,
          "house_type": houseType.dbValue,
          "is_occupied": isAvailable.dbValue,
          "images": images,
          "utilities_attributes":
              utilitiesAttributes, // Note the _attributes suffix
        },
      };
      //print("PAYLOAD IN ACTIONS: $payload");

      ref
          .read(
            housesNotifierProvider((
              estateId: estateId,
              houseId: null,
            )).notifier,
          )
          .addHouse(payload);
      break;
    case NewEstateInput(:String name, :String location, :XFile? image):
      ref.read(estatesProvider.notifier).addEstate({
        "location": location,
        "name": name,
        "image": image,
      });
      break;
  }
}

ActionInput buildAction(
  String formType,
  Map<String, TextEditingController> controllers,
  FormModel? model,
  int? id, {
  XFile? image,
  List<XFile>? images,
}) {
  // Helper to sanitize keys so they match DynamicForm's output
  String sanitize(String type, String label) {
    return "${type.replaceAll(" ", "").toLowerCase()}_${label.replaceAll(" ", "").toLowerCase()}";
  }


  switch (formType.toLowerCase()) {
    case "login":
      // Login usually doesn't have a prefix based on our previous fix
      return LoginInput(
        email: controllers["emailaddress"]?.text ?? "",
        password: controllers["password"]?.text ?? "",
      );

    case "create house":
      // These keys match your log exactly:
      final nameValue = controllers["createhouse_housename"]?.text ?? "";
      final typeValue = controllers["createhouse_housetype"]?.text ?? "";
      final occupiedValue = controllers["createhouse_isoccupied"]?.text ?? "";

      // Utility keys from your log:
      final uName =
          controllers["createhouse_utilities_utilityname"]?.text ?? "";
      final uMeter = controllers["createhouse_utilities_meterno"]?.text ?? "";
      final uRead =
          controllers["createhouse_utilities_lastreading"]?.text ?? "";

      List<UtilityModel> parsedUtilities = [];
      if (uName.isNotEmpty) {
        parsedUtilities.add(
          UtilityModel(
            name: AccountName.values.firstWhere((e) => e.uiValue == uName),
            meterNumber: uMeter,
            lastReading: int.tryParse(uRead) ?? 0,
          ),
        );
      }

      return CreateHouseInput(
        houseName: nameValue,
        houseType: HouseType.fromUiValue(typeValue),
        isAvailable: IsOccupied.fromValues(IsOccupied.toValue(occupiedValue)),
        images: images,
        estateId: id!,
        utilities: parsedUtilities,
      );
    case "create estate":
      final type = "create estate";
      return NewEstateInput(
        name: controllers[sanitize(type, "Name")]?.text ?? "",
        location: controllers[sanitize(type, "Location")]?.text ?? "",
        image: image,
      );

    default:
      throw UnsupportedError("Unknown form type: $formType");
  }
}

Future<bool> showDeleteDialog(BuildContext context, String modelName) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text("Delete $modelName"),
      content: const Text("Do you accept ?"),
      elevation: 24,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Yes", style: Theme.of(context).textTheme.titleSmall),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text("Cancel", style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    ),
  );
}
