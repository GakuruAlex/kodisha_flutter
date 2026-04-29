import 'package:kodisha_flutter/models/form_model.dart';

class UtilityModel implements FormModel {
  UtilityModel({this.name, this.meterNumber, this.lastReading, this.id});

  final String? name;
  final String? meterNumber;
  final String? lastReading;
  @override
  final int? id;
  @override
  Map<String, dynamic> toFormValues() {
    return {};
  }

  factory UtilityModel.fromJson(Map<String, dynamic> utility) {
    return UtilityModel(
      name: utility["name"],
      meterNumber: utility["meter_no"],
      lastReading: utility["last_reading"],
    );
  }
}
