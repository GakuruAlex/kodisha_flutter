import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodisha_flutter/services/api_client.dart';

final landlordServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return LandlordService(dio);
});

class LandlordService {
  final Dio _dio;
  LandlordService(this._dio);

    Future<Response> getEstates() async {
    return await _dio.get('landlord/estates');
  }

  Future<Response> postNewEstate({required FormData data}) async {
    return await _dio.post('landlord/new-estate', data: data);
  }
  Future<Response> updateEstate({required FormData data, required int estateID}) async {
    return await _dio.put('landlord/estates/$estateID', data: data);
  }


  Future<Response> deleteEstate({required int estateID}) async {
    return await _dio.delete('landlord/estates/$estateID');
  }
}
