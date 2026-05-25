import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';

enum HouseType {
  onebedroom('one_bedroom', 'One Bedroom'),
  twobedroom('two_bedroom', 'Two Bedroom'),
  bedsitter('bed_sitter', 'Bed Sitter');

  final String dbValue; // What the database wants ('one_bedroom')
  final String value; // What the user sees/controller holds ('One Bedroom')

  const HouseType(this.dbValue, this.value);

  // 1. Convert DB String back to Enum (For loading from API)
  static HouseType fromDbValue(String? dbValue) {
    return HouseType.values.firstWhere(
      (key) => key.dbValue == dbValue,
      orElse: () => HouseType.bedsitter, // Safe default
    );
  }

  // 2. Convert Controller String to DB String (For saving to API)
  static String toDbValue(String? uiValue) {
    return HouseType.values
        .firstWhere(
          (element) => element.value == uiValue,
          orElse: () => HouseType.bedsitter,
        )
        .dbValue;
  }

  // 3. Convert Controller String to Enum Object (For creating the House model)
  static HouseType fromUiValue(String? uiValue) {
    return HouseType.values.firstWhere(
      (element) => element.value == uiValue,
      orElse: () => HouseType.bedsitter,
    );
  }
}

enum IsOccupied {
  occupied(true, 'Is Available'),
  notoccupied(false, 'Not Available');

  final bool dbValue;
  final String value;
  const IsOccupied(this.dbValue, this.value);

  // Convert DB bool back to Enum (used when loading from API)
  static IsOccupied fromValues(bool? value) {
    return IsOccupied.values.firstWhere(
      (o) => o.dbValue == (value ?? false),
      orElse: () => IsOccupied.notoccupied,
    );
  }

  // Convert Controller String to DB bool (used when saving)
  static bool toValue(String? text) {
    return IsOccupied.values
        .firstWhere(
          (element) => element.value == text,
          orElse: () => IsOccupied.notoccupied, // Default to false if no match
        )
        .dbValue;
  }
}

class House implements FormModel {
  const House({
    this.id,
    this.isOccupied,
    this.name,
    this.images,
    this.houseType,
    this.utilities,
  });
  final IsOccupied? isOccupied;
  final String? name;
  final List<String>? images;
  final HouseType? houseType;
  final List<UtilityModel>? utilities;
  @override
  final int? id;

  House copywith({
    String? name,
    int? id,
    HouseType? houseType,
    List<UtilityModel>? utilities,
    List<String>? images,
    IsOccupied? isOccupied,
  }) {
    return House(
      name: name ?? this.name,
      id: id ?? this.id,
      houseType: houseType ?? this.houseType,
      utilities: utilities ?? this.utilities,
      images: images ?? this.images,
      isOccupied: isOccupied ?? this.isOccupied,
    );
  }

  factory House.fromJson(Map<String, dynamic> house) {
    final List<UtilityModel> utilities = [
      if (house["utilities"] != null)
        ...(house["utilities"] as List).map(
          (utility) => UtilityModel.fromJson(utility),
        ),
    ];

    return House(
      name: house["house_name"],
      id: house["id"],
      isOccupied: IsOccupied.fromValues(house["is_occupied"]),
      houseType: HouseType.fromDbValue(house["house_type"]),
      utilities: utilities,
      images: List<String>.from(house["images"]),
    );
  }
  @override
  Future<Map<String, dynamic>> toJson({
  Map<String, String>? formFields, 
  XFile? image,
  List<XFile>? images,
}) async{
  final finalName = (formFields != null && formFields.containsKey("name"))
      ? formFields["name"]
      : name;

  final finalIsOccupied = (formFields != null && formFields.containsKey("isoccupied"))
      ? formFields["isoccupied"]
      : isOccupied;

  final finalHouseType = (formFields != null && formFields.containsKey("housetype"))
      ? formFields["housetype"]
      : houseType;

  final finalImages = images ?? this.images;

  return {
    "house": {
      if (id != null) "id": id,
      
      "house_name": finalName,
      "images": finalImages,
      "is_occupied": finalIsOccupied,
      "house_type": finalHouseType,
      
      if (utilities != null)
        "utilities_attributes": utilities!.map((utility) {
          return utility.toJson(
            formFields: formFields,
          );
        }).toList(),
    },
  };
}
  @override
  Map<String, dynamic> toFormValues() => {
    "id": id,
    "name": name,
    "houseType": houseType,
    "utilities": utilities,
  };
  @override
  String? get imageUrl => null;
  @override
  List<String>? get imagesUrl => images;
  @override
  String get title => name ?? "";
  @override
  String get subTitle => houseType?.value ?? "";
  @override
  Map<String, String> metaData() => {
    "vacancy": isOccupied!.value,
    //"account name": utilities?[0].name?.uiValue ?? "",
    //"account number": utilities?[0].meterNumber ?? "",
  };
}
