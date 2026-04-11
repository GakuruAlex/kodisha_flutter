import 'package:kodisha_flutter/models/form_model.dart';

class House implements FormModel {
  const House({this.id, this.name});
  final String? name;
  @override
  final int? id;

  House copywith({String? name, int? id}) {
    return House(name: name ?? this.name, id: id ?? this.id);
  }

  factory House.fromJson(Map<String, dynamic> house) {
    return House(name: house["house_name"], id: house["id"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "house": {"house_name": name},
    };
  }

  @override
  Map<String, dynamic> toFormValues() => {"id": id, "name": name};
}
