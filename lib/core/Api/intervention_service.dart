import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';

class InterventionService {
  static Future<Map<String, dynamic>> postIntervention({
    required String state,
    required String goal,
    required String context,
    required String language,
  }) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.intervention,
        data: {
          "state": state,
          "goal": goal,
          "context": context,
          "language": language,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Failed to fetch intervention";
    }
  }
}