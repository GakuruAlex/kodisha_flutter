import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/models/form_model.dart';

enum AccountName {
  wateraccount("water_bill", "Water Account"),
  electricaccount("electricity_bill", "Electricity Account"),
  gasaccount("gas_bill", "Gas Account");

  final String dbValue;
  final String uiValue;

  const AccountName(this.dbValue, this.uiValue);

  static AccountName fromDbValue(String name) {
    return AccountName.values.firstWhere(
      (value) => value.dbValue == name,
      orElse: () => AccountName.wateraccount, 
    );
  }

  static AccountName fromUiValue(String uiName) {
    return AccountName.values.firstWhere(
      (value) => value.uiValue == uiName,
      orElse: () => AccountName.wateraccount,
    );
  }

  static String toDbValue(String uiName) {
    return AccountName.values
        .firstWhere(
          (value) => value.uiValue == uiName,
          orElse: () => AccountName.wateraccount,
        )
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
      "name": name?.uiValue ?? "",
      "meternumber": meterNumber ?? "",
      "lastreading": lastReading?.toString() ?? "",
    };
  }

  factory UtilityModel.fromJson(Map<String, dynamic> utility) {
    // 💡 Robust type checking for numbers coming from Rails
    final rawReading = utility["last_reading"];
    int? parsedReading;
    if (rawReading is int) {
      parsedReading = rawReading;
    } else if (rawReading is String) {
      parsedReading = int.tryParse(rawReading);
    }

    return UtilityModel(
      id: utility["id"] as int?,
      name: AccountName.fromDbValue(utility["name"] ?? "water_bill"),
      meterNumber: utility["meter_no"],
      lastReading: parsedReading,
    );
  }

  @override
  Future<Map<String, dynamic>> toJson({
    Map<String, String>? formFields,
    XFile? image,
    List<XFile>? images,
  }) async{
    final finalNameString =
        (formFields != null && formFields.containsKey("name"))
        ? formFields["name"]
        : null;

    final finalDbName = finalNameString != null
        ? AccountName.fromUiValue(finalNameString).dbValue
        : name?.dbValue ?? AccountName.wateraccount.dbValue;

    final finalMeterNo =
        (formFields != null && formFields.containsKey("meternumber"))
        ? formFields["meternumber"]
        : meterNumber;

    final finalReadingString =
        (formFields != null && formFields.containsKey("lastreading"))
        ? formFields["lastreading"]
        : null;

    final finalReading = finalReadingString != null
        ? int.tryParse(finalReadingString)
        : lastReading;

    return {
      if (id != null) "id": id,
      "name": finalDbName,
      "meter_no": finalMeterNo,
      "last_reading": finalReading,
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
