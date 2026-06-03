import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/features/doctors/modules/doctordetails.dart';

class DoctorsService {
  static String apiMesssege="";
  
  static Future<List<DoctorDetails>> getAllDoctors() async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.getAllDoctors,
        queryParameters: {
          "category": "Therapist",
          "page": 1,
        },
      );
      if (response.data['status'] == 'success') {
        final List professionals = response.data['data']['professionals'];
        return professionals.map((e) => DoctorDetails.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      apiMesssege = e.response?.data["message"] ?? "Failed to fetch doctors";
      throw apiMesssege;
    }
  }

  static Future<Map<String, dynamic>> bookSession({
    required String professionalId,
    required DateTime startTime,
    required DateTime endTime,
    required String paymentMethod,
    String? paymentReference,
    required File paymentProof,
  }) async {
    try {
      final formData = FormData.fromMap({
        "professionalId": professionalId,
        "start_time": startTime.toUtc().toIso8601String(),
        "end_time": endTime.toUtc().toIso8601String(),
        "payment_method": paymentMethod,
        if (paymentReference != null && paymentReference.isNotEmpty)
          "payment_reference": paymentReference,
        "paymentProof": await MultipartFile.fromFile(
          paymentProof.path,
          filename: paymentProof.path.split('/').last,
        ),
      });

      final response = await DioFactory.postFormData(
        path: "/api/v1/sessions/book",
        data: formData,
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      apiMesssege = e.response?.data["message"] ?? "Failed to book session";
      throw apiMesssege;
    }
  }

  static Future<List<Map<String, dynamic>>> getMySessions() async {
    try {
      final response = await DioFactory.getData(
        path: "/api/v1/sessions/my-sessions",
      );
      if (response.data['status'] == 'success') {
        final List sessions = response.data['data']['sessions'];
        return sessions.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      apiMesssege = e.response?.data["message"] ?? "Failed to fetch sessions";
      throw apiMesssege;
    }
  }
}