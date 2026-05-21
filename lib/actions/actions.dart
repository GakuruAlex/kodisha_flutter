import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';
import 'package:kodisha_flutter/provider/landlord/estates_provider.dart';
import 'package:kodisha_flutter/provider/landlord/house_provider.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';

sealed class ActionInput {}

class LoginInput extends ActionInput {
  LoginInput({required this.email, required this.password});
  final String email;
  final String password;
}

class FormSubmitInput extends ActionInput {
  FormSubmitInput({required this.formType, required this.payload, this.id});
  final String formType;
  final Map<String, dynamic>
  payload;
  final int? id;
}

class CreateHouseInput extends ActionInput {
  CreateHouseInput({
    required this.houseName,
    required this.estateId,
    required this.images,
    required this.houseType,
    required this.isAvailable,
    this.utilities,
  });
  final String houseName;
  final IsOccupied isAvailable;
  final int estateId;
  final List<XFile>? images;
  final HouseType houseType;
  final List<UtilityModel>? utilities;
}

class NewEstateInput extends ActionInput {
  NewEstateInput({required this.name, required this.location, this.image});
  final String location;
  final String name;
  final XFile? image;
}

ActionInput buildAction(
  String formType,
  Map<String, TextEditingController> controllers,
  FormModel? model,
  int? id, {
  XFile? image,
  List<XFile>? images,
}) {
  final normalizedFormType = formType.toLowerCase();

  if (normalizedFormType == "login") {
    return LoginInput(
      email: controllers["login_emailaddress"]?.text ?? "",
      password: controllers["login_password"]?.text ?? "",
    );
  }

  final Map<String, String> extractedFields = {};
  controllers.forEach((key, controller) {
    if (key.contains('_')) {
      final cleanKey = key.substring(key.lastIndexOf('_') + 1);
      extractedFields[cleanKey] = controller.text;
    } else {
      extractedFields[key] = controller.text;
    }
  });

  final isEdit = normalizedFormType.contains("edit");

  if (isEdit && model != null) {
    return FormSubmitInput(
      formType: normalizedFormType,
      id: id ?? model.id,
      payload: model.toJson(
        formFields: extractedFields,
        image: image,
        images: images,
      ),
    );
  }

  if (normalizedFormType.contains("estate")) {
    return NewEstateInput(
      name: extractedFields["name"] ?? "",
      location: extractedFields["location"] ?? "",
      image: image,
    );
  }

  if (normalizedFormType.contains("house")) {
    final utilityName = extractedFields["utilityname"] ?? "";
    List<UtilityModel> parsedUtilities = [];

    if (utilityName.isNotEmpty) {
      parsedUtilities.add(
        UtilityModel(
          name: AccountName.values.firstWhere(
            (e) => e.uiValue == utilityName,
            orElse: () => AccountName.wateraccount,
          ),
          meterNumber: extractedFields["meterno"] ?? "",
          lastReading: int.tryParse(extractedFields["lastreading"] ?? "") ?? 0,
        ),
      );
    }

    return CreateHouseInput(
      houseName: extractedFields["housename"] ?? "",
      houseType: HouseType.fromUiValue(extractedFields["housetype"] ?? ""),
      isAvailable: IsOccupied.fromValues(
        IsOccupied.toValue(extractedFields["isoccupied"] ?? ""),
      ),
      images: images,
      estateId:
          id ?? 0,
      utilities: parsedUtilities,
    );
  }

  throw UnsupportedError(
    "Gate routing failed. Unknown form configuration signature: $formType",
  );
}

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
      final List<Map<String, dynamic>> utilitiesAttributes =
          utilities?.map((u) {
            return {
              "name": u.name?.dbValue ?? AccountName.wateraccount.dbValue,
              "meter_no": u.meterNumber ?? "",
              "last_reading": u.lastReading ?? 0,
            };
          }).toList() ??
          [];

      final Map<String, dynamic> payload = {
        "house": {
          "house_name": houseName,
          "house_type": houseType.dbValue,
          "is_occupied": isAvailable.dbValue,
          "images": images,
          "utilities_attributes": utilitiesAttributes,
        },
      };

      ref
          .read(
            housesNotifierProvider((
              estateId: estateId,
              houseId: null,
            )).notifier,
          )
          .addHouse(payload);
      break;

    case FormSubmitInput(
      :String formType,
      :Map<String, dynamic> payload,
      :int? id,
    ):
      if (formType.contains("estate")) {
        //ref.read(estatesProvider.notifier).updateEstate(id!, payload);
      } else if (formType.contains("house")) {
        // ref.read(housesNotifierProvider((estateId: id ?? 0, houseId: id)).notifier)
        //     .updateHouse(payload);
      }
      break;
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
