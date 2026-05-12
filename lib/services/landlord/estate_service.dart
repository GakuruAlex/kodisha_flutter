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

    // text fields
    // Ensure everything added to .fields is a .toString()
    formData.fields.add(
      MapEntry('house[house_name]', data['name']?.toString() ?? ''),
    );
    formData.fields.add(
      MapEntry('house[house_type]', data['house_type']?.toString() ?? ''),
    );
    formData.fields.add(
      MapEntry(
        'house[is_occupied]',
        data['is_occupied']?.toString() ?? 'false',
      ),
    );

    // images
    if (data["images"] != null && data["images"].isNotEmpty) {
      for (var image in data["images"]) {
        formData.files.add(
          MapEntry(
            'house[images][]',
            await MultipartFile.fromFile(image.path, filename: image.name),
          ),
        );
      }
    }

    final options = Options(
      method: "POST",
      headers: {"Authorization": "Bearer $token"},
    );

    try {
      final response = await dio.post(
        "$estateUrl/$estateId/houses",
        options: options,
        data: formData,
      );

      return response;
    } on DioException catch (e) {
      throw e.response?.data ?? e.message ?? "Upload failed";
    }
  }
}
