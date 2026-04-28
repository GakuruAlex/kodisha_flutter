import 'package:kodisha_flutter/models/form_model.dart';

class BillModel extends FormModel {
  BillModel({required this.name, required this.accountNumber, this.id});

  final String name;
  @override
  final int? id;
  final String accountNumber;

  @override
  Map<String, dynamic> toFormValues() {
    return {"name": name, "account number": accountNumber};
  }
}
