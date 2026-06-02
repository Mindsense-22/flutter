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
}