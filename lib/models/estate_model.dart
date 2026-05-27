import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/models/house_model.dart';

class Estate implements FormModel {
  const Estate({
    this.id,
    this.location,
    this.name,
    this.numHouses,
    this.vacancy,
    this.houses,
    this.estateImage,
  });

  final String? location;
  final List<House>? houses;
  final bool? vacancy;
  final String? name;
  final int? numHouses;
  @override
  final int? id;
  final String? estateImage;

  Estate copywith({
    String? location,
    String? name,
    int? numHouses,
    int? id,
    String? estateImage,
    bool? vacancy,
    List<House>? houses,
  }) {
    List<dynamic> housesE = houses ?? [];
    List<House> estateHouses = housesE
        .map((house) => House.fromJson(house))
        .toList();

    return Estate(
      vacancy: vacancy ?? this.vacancy,
      estateImage: estateImage ?? this.estateImage,
      location: location ?? this.location,
      name: name ?? this.name,
      id: id ?? this.id,
      numHouses: numHouses ?? this.numHouses,
      houses: estateHouses,
    );
  }

  factory Estate.empty() => const Estate();
  factory Estate.fromJson(Map<String, dynamic> estate) {
    List<dynamic> housesE = estate["houses"] ?? [];
    List<House> estateHouses = housesE
        .map((house) => House.fromJson(house))
        .toList();
    return Estate(
      location: estate["location"],
      name: estate["name"],
      id: estate["id"],
      numHouses: estate["houses_count"],
      vacancy: estate["has_vacancy"],
      houses: estateHouses,
      estateImage: estate["image"],
    );
  }
  @override
  Map<String, dynamic> toJson({
    Map<String, String>? formFields,
    XFile? image,
    List<XFile>? images,
  }) {
    final finalName = (formFields != null && formFields.containsKey("name"))
        ? formFields["name"]
        : name;

    final finalLocation =
        (formFields != null && formFields.containsKey("location"))
        ? formFields["location"]
        : location;

    final finalImage = image ?? estateImage;

    return {
      "estate": {
        "name": finalName,
        "location": finalLocation,
        "image": finalImage,
      },
    };
  }

  @override
  Map<String, dynamic> toFormValues() => {
    "id": id,
    "location": location,
    "name": name,
  };
  @override
  String? get imageUrl => estateImage;
  @override
  String get title => name ?? "";
  @override
  String get subTitle => location ?? "";
  @override
  Map<String, String> metaData() => {
    "Number of houses": "$numHouses",
    "Vacancy": vacancy! ? "Available" : "Taken",
  };
  @override
  List<String>? get imagesUrl => [];
}
