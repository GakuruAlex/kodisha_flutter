import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class EstateService {
  final estateUrl = dotenv.env["LANDLORD_ESTATE_BASE_URL"];
  Future<Response> postHouse({
    required Map<String, dynamic> data,
    required String token,
    required int estateId,
  }) async {
    final options = Options(
      method: "POST",
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "Application/json",
      },
    );

    try {
      final response = await dio.post(
        "$estateUrl/$estateId/houses",
        options: options,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw "${e.error}";
    }
  }
}
