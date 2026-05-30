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

  final Map<String, String> extractedFields = {};
  controllers.forEach((key, controller) {
    if (key.contains('_')) {
      final cleanKey = key.substring(key.lastIndexOf('_') + 1);
      extractedFields[cleanKey] = controller.text;
    } else {
      extractedFields[key] = controller.text;
    }
  });

  final FormTarget target;
  if (normalizedFormType.contains("estate")) {
    target = FormTarget.estate;
  } else if (normalizedFormType.contains("house")) {
    target = FormTarget.house;
  } else {
    throw UnsupportedError("Gate routing failed. Unknown signature: $formType");
  }

  final isEditing =
      normalizedFormType.contains("edit") ||
      normalizedFormType.contains("update") ||
      model != null;

  Map<String, dynamic> payload;

  if (model != null) {
    payload = model.toJson(
      formFields: extractedFields,
      image: image,
      images: images,
    );
  } else {
    payload = _generateCreatePayload(
      target,
      extractedFields,
      image,
      images,
      isEditing ? null : id,
    );
  }

  return FormSubmitInput(
    target: target,
    payload: payload,
    id: isEditing ? (model?.id ?? id) : null,
  );
}

Map<String, dynamic> _generateCreatePayload(
  FormTarget target,
  Map<String, String> fields,
  XFile? image,
  List<XFile>? images,
  int? parentId,
) {
  switch (target) {
    case FormTarget.estate:
      return {
        "estate": {
          "name": fields["name"] ?? "",
          "location": fields["location"] ?? "",
          "image": image,
        },
      };

    case FormTarget.house:
      final utilityName = fields["utilityname"] ?? "";
      List<Map<String, dynamic>> utilitiesAttributes = [];

      if (utilityName.isNotEmpty) {
        final account = AccountName.values.firstWhere(
          (e) => e.uiValue == utilityName,
          orElse: () => AccountName.wateraccount,
        );
        utilitiesAttributes.add({
          "name": account.dbValue,
          "meter_no": fields["meterno"] ?? "",
          "last_reading": int.tryParse(fields["lastreading"] ?? "") ?? 0,
        });
      }

      return {
        "estate_id": parentId,
        "house": {
          "house_name": fields["housename"] ?? "",
          "house_type": HouseType.fromUiValue(
            fields["housetype"] ?? "",
          ).dbValue,
          "is_occupied": IsOccupied.fromValues(
            IsOccupied.toValue(fields["isoccupied"] ?? ""),
          ).dbValue,
          "images": images,
          "utilities_attributes": utilitiesAttributes,
        },
      };
  }
}
