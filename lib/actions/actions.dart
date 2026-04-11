import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';
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
  CreateHouseInput({required this.houseName, required this.estateId});
  final String houseName;
  final int estateId;
}

void runAction(ActionInput action, WidgetRef ref) {
  switch (action) {
    case LoginInput(:String email, :String password):
      ref.read(loginNotifier.notifier).loginUser(email, password);
      break;
    case CreateHouseInput(:String houseName, :int estateId):
      ref
          .read(housesNotifierProvider(estateId).notifier)
          .addHouse(House(name: houseName));
      ref.read(estatesProvider.notifier).updateEstateHousesNumber(id: estateId);
      break;
  }
}

ActionInput buildAction(
  String formType,
  Map<String, TextEditingController> controllers,
  FormModel? model,
  int? id,
) {
  switch (formType.toLowerCase()) {
    case "login":
      return LoginInput(
        email: controllers["emailaddress"]!.text,
        password: controllers["password"]!.text,
      );
    case "create house":
      return CreateHouseInput(
        houseName: controllers["housename"]!.text,
        estateId: id!,
      );
    default:
      throw UnsupportedError("Unknown form type: $formType");
  }
}
