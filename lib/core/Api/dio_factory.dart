import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';

class DioFactory {
  static late Dio dio;
  static Future init() async {   
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,  
        connectTimeout: Duration(seconds: 15)   
           
      ),
    );
    
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = SharedPreferencesitem.getString("token");
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }
  
  static Future<Response> postData({
    required String path,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    final response = await dio.post(
      path,
      data: data,
      options: token != null ? Options(headers: {"Authorization": "Bearer $token"}) : null,
    );
    return response;
  }

  static Future<Response> postFormData({
    required String path,
    required FormData data,
    String? token,
  }) async {
    final response = await dio.post(
      path,
      data: data,
      options: token != null ? Options(headers: {"Authorization": "Bearer $token"}) : null,
    );
    return response;
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    final response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: token != null ? Options(headers: {"Authorization": "Bearer $token"}) : null,
    );
    return response;
  }
  
  static Future<Response> patchData({
    required String path,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    final response = await dio.patch(
      path,
      data: data,
      options: token != null ? Options(headers: {"Authorization": "Bearer $token"}) : null,
    );
    return response;
  }

  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? data,
    String? token,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: token != null ? Options(headers: {"Authorization": "Bearer $token"}) : null,
    );
    return response;
  }
}
