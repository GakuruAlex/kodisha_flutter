import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class LandlordService {
  final String landlordUrl = dotenv.env["LANDLORD_BASE_URL"]!;

  Future<List<dynamic>> getEstates(String token) async {
    final options = Options(
      method: "GET",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    try {
      final response = await dio.get("$landlordUrl/estates", options: options);
      return response.data;
    } on DioException catch (e) {
      throw '$e.response?.data["error]';
    }
  }

  Future<Response> postNewEstate({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    final options = Options(
      method: "POST",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      final response = await dio.post(
        "$landlordUrl/new-estate",
        options: options,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw "${e.response?.data["error"]}";
    }
  }
}
