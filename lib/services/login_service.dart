import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/services/api_client.dart';

final loginServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return LoginService(dio);
});

class LoginService {
  final Dio _dio;
  LoginService(this._dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '/login',
      data: {'email_address': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }
}
