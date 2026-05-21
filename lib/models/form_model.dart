import 'package:image_picker/image_picker.dart';

abstract class FormModel {
  int? get id;
  String? get imageUrl;
  String get title;
  String get subTitle;
  List<String>? get imagesUrl;
  Map<String, String> metaData();
  Map<String, dynamic> toFormValues();
  Map<String, dynamic> toJson({
    Map<String, String>? formFields,
    XFile? image,
    List<XFile>? images,
  });
}
