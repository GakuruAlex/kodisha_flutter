import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodisha_flutter/services/api_client.dart';

final landlordServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return LandlordService(dio);
});

class LandlordService {
  final Dio _dio;
  LandlordService(this._dio);

  // Notice we don't pass the token manually anymore! The Interceptor handles it.
  Future<Response> getEstates() async {
    return await _dio.get('landlord/estates');
  }

  Future<Response> postNewEstate({required Map<String, dynamic> data}) async {
    final Map<String, dynamic> mapWithMultipart = Map.from(data);
    debugPrint("FORMDATA $mapWithMultipart");

    if (mapWithMultipart['image'] is XFile) {
      final XFile file = mapWithMultipart['image'];

      mapWithMultipart['image'] = await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      );
    }

    final formData = FormData.fromMap(mapWithMultipart);

    return await _dio.post('landlord/new-estate', data: formData);
  }

  Future<Response> deleteEstate({required int estateID}) async {
    return await _dio.delete('landlord/estates/$estateID');
  }
}
