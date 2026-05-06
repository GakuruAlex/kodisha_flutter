import 'package:kodisha_flutter/models/form_model.dart';
import 'package:kodisha_flutter/models/utility_model.dart';

enum HouseType { onebedroom, twobedroom, bedsitter }

class House implements FormModel {
  const House({
    this.id,
    this.name,
    this.images,
    this.houseType,
    this.utilities,
  });
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
  }) {
    return House(
      name: name ?? this.name,
      id: id ?? this.id,
      houseType: houseType ?? this.houseType,
      utilities: utilities ?? this.utilities,
      images: images ?? this.images,
    );
  }

  factory House.fromJson(Map<String, dynamic> house) {
    // final List<UtilityModel> utilities = house["utilities"].map(
    //   (utitlity) => utitlity.fromJson(),
    // );
    return House(
      name: house["house_name"],
      id: house["id"],
      //utilities: utilities,
      images: List<String>.from(house["images"]),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "house": {"house_name": name, "images": images},
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
  String? get imageUrl => "";
  @override
  List<String>? get imagesUrl => images;
  @override
  String get title => name ?? "";
  @override
  String get subTitle => houseType?.name ?? "";
  @override
  Map<String, String> metaData() => {
    "account number": utilities?[0].meterNumber ?? "",
    "account name": utilities?[0].name ?? "",
  };
}
