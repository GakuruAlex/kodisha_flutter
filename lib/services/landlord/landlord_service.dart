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
}
