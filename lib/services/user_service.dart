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

  Future<Response> postUser({
    required String token,
    required Map<String, Map<dynamic, dynamic>> data,
  }) async {
    try {
      final response = await dio.post(
        '$url',
        data: data,
        options: Options(
          method: "POST",
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw '${e.response?.data}';
    }
  }

  Future<Response> destroyUser({required String token, required int id}) async {
    try {
      final response = await dio.delete(
        '$url/$id',
        options: Options(
          method: "DELETE",
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response;
    } on DioException catch (e) {
      throw '${e.response?.data}';
    }
  }

  Future<Response> update({
    required String token,
    required int id,
    required data,
  }) async {
    try {
      final response = await dio.patch(
        '$url/$id',
        options: Options(
          method: "PATCH",
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw '${e.response?.data}';
    }
  }
}
