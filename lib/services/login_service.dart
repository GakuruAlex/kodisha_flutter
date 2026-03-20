import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class LoginService {
  final loginUrl = dotenv.env["LOGIN_URL"];
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await dio.post(
        'http://localhost:3000/login', // adjust to your backend URL
        data: {'email_address': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Login success: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('Login failed: ${e.response?.statusCode} ${e.response?.data}');
      return null;
    }
  }
}
