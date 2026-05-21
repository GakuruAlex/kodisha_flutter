import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';
import 'form_inputs.dart';

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

  // Namespace stripping loop: e.g., "createhouse_housename" -> "housename"
  final Map<String, String> extractedFields = {};
  controllers.forEach((key, controller) {
    if (key.contains('_')) {
      final cleanKey = key.substring(key.lastIndexOf('_') + 1);
      extractedFields[cleanKey] = controller.text;
    } else {
      extractedFields[key] = controller.text;
    }
  });

  if (normalizedFormType.contains("edit") && model != null) {
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
      estateId: id ?? 0,
      utilities: parsedUtilities,
    );
  }

  throw UnsupportedError("Gate routing failed. Unknown signature: $formType");
}