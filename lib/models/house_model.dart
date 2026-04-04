class House {
  const House({this.id, this.name});
  final String? name;
  final int? id;

  House copywith({String? name, int? id}) {
    return House(name: name ?? this.name, id: id ?? this.id);
  }

  factory House.fromJson(Map<String, dynamic> house) {
    return House(name: house["house_name"], id: house["id"]);
  }
}
