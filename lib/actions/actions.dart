import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
  CreateHouseInput({
    required this.houseName,
    required this.estateId,
    required this.images,
    required this.houseType,
    required this.isAvailable,
  });
  final String houseName;
  final IsOccupied isAvailable;
  final int estateId;
  final List<XFile>? images;
  final HouseType houseType;
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
    ):
      ref
          .read(
            housesNotifierProvider((
              estateId: estateId,
              houseId: null,
            )).notifier,
          )
          .addHouse({
            "name": houseName,
            "images": images,
            "house_type": houseType.dbValue,
            "is_occupied": isAvailable.dbValue,
          });
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
  switch (formType.toLowerCase()) {
    case "login":
      return LoginInput(
        email: controllers["emailaddress"]!.text,
        password: controllers["password"]!.text,
      );
    case "create house":
      return CreateHouseInput(
        houseName: controllers["housename"]!.text,
        // Use the helper that returns the Enum object directly
        isAvailable: IsOccupied.fromValues(
          IsOccupied.toValue(controllers["isoccupied"]!.text),
        ),
        images: images,
        estateId: id!,
        houseType: HouseType.fromUiValue(controllers["housetype"]!.text),
      );
    case "create estate":
      return NewEstateInput(
        name: controllers["name"]!.text,
        location: controllers["location"]!.text,
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
      content: Text("Do you accept ?"),
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
