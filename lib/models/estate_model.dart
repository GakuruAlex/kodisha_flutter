import 'package:kodisha_flutter/models/house_model.dart';

class Estate {
  const Estate({
    this.id,
    this.location,
    this.name,
    this.numHouses,
    this.vacancy,
    this.houses,
  });

  final String? location;
  final List<House>? houses;
  final bool? vacancy;
  final String? name;
  final int? numHouses;
  final int? id;

  Estate copywith({
    String? location,
    String? name,
    int? numHouses,
    int? id,
    bool? vacancy,
    List<House>? houses,
  }) {
    return Estate(
      vacancy: vacancy ?? this.vacancy,
      location: location ?? this.location,
      name: name ?? this.name,
      id: id ?? this.id,
      numHouses: numHouses ?? this.numHouses,
      houses: houses ?? this.houses ?? [],
    );
  }

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
    );
  }
  Map<String, Map<dynamic, dynamic>> toJson() {
    return {
      "estate": {"location": location, "name": name},
    };
  }
}
