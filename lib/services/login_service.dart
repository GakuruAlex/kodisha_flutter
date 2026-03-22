import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class LoginService {
  final loginUrl = dotenv.env["LOGIN_URL"];
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        loginUrl!,
        data: {'email_address': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      //print('Login success: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data == null) {
        throw '${e.error}';
      }
      throw '${e.response?.data["error"]}';
    }
  }
}
