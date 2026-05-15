import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class LandlordService {
  final String landlordUrl = dotenv.env["LANDLORD_BASE_URL"]!;

  Future<Response> getEstates(String token) async {
    final options = Options(
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    try {
      return await dio.get("$landlordUrl/estates", options: options);
    } on DioException catch (e) {
      throw e.response?.data["error"] ?? e.message ?? "Failed to fetch estates";
    }
  }

  Future<Response> postNewEstate({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final formData = FormData();
    //print("ESTATE DATA: $data");
    // Check if data is already wrapped in 'estate' from runAction
    final estateData = data.containsKey('estate') ? data['estate'] : data;
    //print("ESTATE DATA: $estateData");

    // text fields - using Rails 'estate[field]' naming convention
    formData.fields.addAll([
      MapEntry('estate[name]', estateData['name']?.toString() ?? ''),
      MapEntry('estate[location]', estateData['location']?.toString() ?? ''),
    ]);

    final image = estateData['image'];
    if (image != null) {
      formData.files.add(
        MapEntry(
          'estate[image]',
          await MultipartFile.fromFile(image.path, filename: image.name),
        ),
      );
    }

    try {
      return await dio.post(
        "$landlordUrl/new-estate",
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw e.response?.data["error"] ?? "Failed to create estate";
    }
  }

  Future<Response> deleteEstate({
    required String token,
    required int estateID,
  }) async {
    final options = Options(
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    try {
      return await dio.delete(
        "$landlordUrl/estates/$estateID",
        options: options,
      );
    } on DioException catch (e) {
      throw e.response?.data["error"] ?? "Delete failed";
    }
  }
}
