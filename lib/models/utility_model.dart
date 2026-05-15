import 'package:kodisha_flutter/models/form_model.dart';

enum AccountName {
  wateraccount("water_bill", "Water Account"),
  electricaccount("electricity_bill", "Electricity Account"),
  gasaccount("gas_bill", "Gas Account");

  final String dbValue;
  final String uiValue;

  const AccountName(this.dbValue, this.uiValue);

  static AccountName fromDbValue(String name) {
    return AccountName.values.firstWhere((value) => value.dbValue == name);
  }

  static String toDbValue(String uiName) {
    return AccountName.values
        .firstWhere((value) => value.uiValue == uiName)
        .dbValue;
  }
}

class UtilityModel implements FormModel {
  UtilityModel({this.name, this.meterNumber, this.lastReading, this.id});

  final AccountName? name;
  final String? meterNumber;
  final int? lastReading;
  @override
  final int? id;
  @override
  Map<String, dynamic> toFormValues() {
    return {
      "$name.uiValue": name?.uiValue ?? "",
      "meternumber": meterNumber ?? "",
      "lastreading": lastReading?.toString() ?? "",
    };
  }

  factory UtilityModel.fromJson(Map<String, dynamic> utility) {
    return UtilityModel(
      name: AccountName.fromDbValue(utility["name"] ?? "water_bill"),
      meterNumber: utility["meter_no"],
      lastReading: int.tryParse(utility["last_reading"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": AccountName.toDbValue("name"),
      "meter_no": "meter_no",
      "last_reading": "last_reading",
    };
  }

  @override
  String? get imageUrl => "";
  @override
  String get subTitle => meterNumber ?? "";
  @override
  String get title => name?.uiValue ?? "";
  @override
  List<String>? get imagesUrl => [];
  @override
  Map<String, String> metaData() => {"last reading": "$lastReading"};
}
