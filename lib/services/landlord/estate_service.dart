import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class EstateService {
  final estateUrl = dotenv.env["LANDLORD_ESTATE_BASE_URL"];
  Future<Response> postHouse({
    required Map<String, dynamic> data,
    required String token,
    required int estateId,
  }) async {
    final formData = FormData();

    // 1. Extract the actual house data (since we wrapped it in 'house' in runAction)
    final houseData = data['house'] as Map<String, dynamic>;

    // 2. Add Basic Text Fields
    formData.fields.addAll([
      MapEntry('house[house_name]', houseData['house_name']?.toString() ?? ''),
      MapEntry('house[house_type]', houseData['house_type']?.toString() ?? ''),
      MapEntry(
        'house[is_occupied]',
        houseData['is_occupied']?.toString() ?? 'false',
      ),
    ]);

    // 3. Add Nested Utilities Attributes
    final utilities =
        houseData['utilities_attributes'] as List<Map<String, dynamic>>?;
    if (utilities != null) {
      for (int i = 0; i < utilities.length; i++) {
        final utility = utilities[i];
        // Rails expects this specific indexed format for nested attributes
        formData.fields.add(
          MapEntry(
            'house[utilities_attributes][$i][name]',
            utility['name'].toString(),
          ),
        );
        formData.fields.add(
          MapEntry(
            'house[utilities_attributes][$i][meter_no]',
            utility['meter_no'].toString(),
          ),
        );
        formData.fields.add(
          MapEntry(
            'house[utilities_attributes][$i][last_reading]',
            utility['last_reading'].toString(),
          ),
        );
      }
    }

    // 4. Add Images
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

    final options = Options(headers: {"Authorization": "Bearer $token"});

    try {
      return await dio.post(
        "$estateUrl/$estateId/houses",
        options: options,
        data: formData,
      );
    } on DioException catch (e) {
      throw e.response?.data ?? e.message ?? "Upload failed";
    }
  }
}
