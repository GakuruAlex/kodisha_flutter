import 'package:dio/dio.dart';
import 'package:kodisha_flutter/services/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final estateServiceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return EstateService(dio);
});

class EstateService {
  final Dio _dio;

  EstateService(this._dio);

  Future<Response> postHouse({
    required Map<String, dynamic> data,
    required int estateId,
  }) async {
    final formData = FormData();
    //debugPrint("Constructing FormData for house with data: $data");

    final houseData = data['house'] as Map<String, dynamic>;

    formData.fields.addAll([
      MapEntry('house[house_name]', houseData['house_name']?.toString() ?? ''),
      MapEntry('house[house_type]', houseData['house_type']?.toString() ?? ''),
      MapEntry(
        'house[is_occupied]',
        houseData['is_occupied']?.toString() ?? 'false',
      ),
    ]);

    final utilities = houseData['utilities_attributes'] as List<dynamic>?;
    if (utilities != null) {
      for (int i = 0; i < utilities.length; i++) {
        final utility = utilities[i] as Map<String, dynamic>;

        formData.fields.addAll([
          MapEntry(
            'house[utilities_attributes][$i][name]',
            utility['name']?.toString() ?? '',
          ),
          MapEntry(
            'house[utilities_attributes][$i][meter_no]',
            utility['meter_no']?.toString() ?? '',
          ),
          MapEntry(
            'house[utilities_attributes][$i][last_reading]',
            utility['last_reading']?.toString() ?? '',
          ),
        ]);
      }
    }

    if (houseData["images"] != null && houseData["images"].isNotEmpty) {
      for (var image in houseData["images"]) {
        formData.files.add(
          MapEntry(
            'house[images][]',
            await MultipartFile.fromFile(image.path, filename: image.name),
          ),
        );
      }
    }

    return await _dio.post("landlord/estate/$estateId/houses", data: formData);
  }
}
