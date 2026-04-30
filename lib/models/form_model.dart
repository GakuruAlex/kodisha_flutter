abstract class FormModel {
  int? get id;
  String? get imageUrl;
  String get title;
  String get subTitle;
  List<String>? get imagesUrl;
  Map<String, String> metaData();
  Map<String, dynamic> toFormValues();
}
