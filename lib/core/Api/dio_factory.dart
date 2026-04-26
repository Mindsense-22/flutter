import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';

class DioFactory {
  static late Dio dio;
  static Future init() async {   
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,  
        connectTimeout: Duration(seconds: 15)   
           
      ),
    );
  }
static Future<Response> postData({
    required String path,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    final response = await dio.post(
      path,
      data: data, 
    );
    return response;
  }

  static Future<Response> getData({
    required String path,
    String? token,
  }) async {
    final response = await dio.get(
      path,
    );
    return response;
  }
  
}