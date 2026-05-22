import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/provider/login_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.env["API_URL"];

  final dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(loginNotifier).value?.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        if (error.response?.statusCode == 401) {
          ref.read(loginNotifier.notifier).logout();
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
});
