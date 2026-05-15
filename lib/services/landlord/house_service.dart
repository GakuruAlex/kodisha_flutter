import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final dio = Dio();

class HouseService {
  final estateUrl = dotenv.env["LANDLORD_ESTATE_BASE_URL"];

  Future<Response> getHouses(String token, int estateId)async{
    final options = Options(
      method: "GET",
      headers: {
        "Authorization": "Bearer $token"
      }
    
    );
    try{

      final response = await dio.get("$estateUrl/$estateId/houses", options: options);
      return response;

    }
    on DioException catch(error){
      throw "${error.response?.data}";
    }
  }


  Future<Response> getHouse(String token, int estateId, int houseId) async{
    final options = Options(
      method: "GET",
      headers: {
        "Authorization": "Bearer $token"
      }
    
    );
    try{

      final response = await dio.get("$estateUrl/$estateId/houses/$houseId", options: options);
      return response;

    }
    on DioException catch(error){
      throw "${error.response?.data}";
    }

  }
}
