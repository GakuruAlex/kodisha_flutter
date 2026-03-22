import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class UserService {
  final url = dotenv.env["USERS_URL"];

  Future<List<dynamic>> fetchUsers(String token) async {
    try {
      final response = await dio.get(
        '$url',
        options: Options(
          method: "GET",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw '${e.response?.data["error"]}';
    }
  }
}
