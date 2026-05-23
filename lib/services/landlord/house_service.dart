import 'package:dio/dio.dart';

class HouseService {
  final Dio _dio;

  // 🔑 Inject the interceptor-configured Dio client via constructor
  HouseService(this._dio);

  /// Fetches all houses matching a specific estate ID
  Future<Response> getHouses(int estateId) async {
    // Relative path works perfectly because the base URL is globally managed
    return await _dio.get("landlord/estate/$estateId/houses");
  }

  /// Fetches details for a single specific house
  Future<Response> getHouse(int estateId, int houseId) async {
    return await _dio.get("landlord/estate/$estateId/houses/$houseId");
  }
}