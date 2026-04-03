class Estate {
  const Estate({
    this.id,
    this.location,
    this.name,
    this.numHouses,
    this.vacancy,
  });

  final String? location;
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
  }) {
    return Estate(
      vacancy: vacancy ?? this.vacancy,
      location: location ?? this.location,
      name: name ?? this.name,
      id: id ?? this.id,
      numHouses: numHouses ?? this.numHouses,
    );
  }

  factory Estate.fromJson(Map<String, dynamic> estate) {
    return Estate(
      location: estate["location"],
      name: estate["name"],
      id: estate["id"],
      numHouses: estate["houses_count"],
      vacancy: estate["has_vacancy"],
    );
  }
  Map<String, Map<dynamic, dynamic>> toJson() {
    return {
      "estate": {"location": location, "name": name},
    };
  }
}
