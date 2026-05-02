import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';

class EmotionService {
  static String apiMesssege="";
  static Future<Map<String, dynamic>> analyzeFace(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: "face.jpg"),
      });

      final response = await DioFactory.postFormData(
        path: ApiConstants.analyzeFace,
        data: formData,
      );

      return response.data;
    } on DioException catch (e) {
      apiMesssege = e.response?.data["message"] ?? "Unknown error";
      throw apiMesssege;
    }
  }

  static Future<Map<String, dynamic>> analyzeVoice(File audioFile) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(audioFile.path, filename: "voice.wav"),
      });

      final response = await DioFactory.postFormData(
        path: ApiConstants.analyzeVoice,
        data: formData,
      );

      return response.data;
    } on DioException catch (e) {
      apiMesssege = e.response?.data["message"] ?? "Failed to analyze voice";
      throw apiMesssege;
    }
  }

  static Future<Map<String, dynamic>> analyzeAll(File faceFile, File voiceFile) async {
    try {
      FormData formData = FormData.fromMap({
        "face": await MultipartFile.fromFile(faceFile.path, filename: "face.jpg"),
        "voice": await MultipartFile.fromFile(voiceFile.path, filename: "voice.wav"),
      });

      final response = await DioFactory.postFormData(
        path: ApiConstants.analyzeAll,
        data: formData,
      );

      return response.data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Failed to perform combined analysis";
    }
  }
  static Future<Map<String, dynamic>> getEmotionHistory({
    int? limit,
    String? source,
    String? from,
    String? to,
  }) async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.emotionHistory,
        queryParameters: {
          if (limit != null) "limit": limit,
          if (source != null) "source": source,
          if (from != null) "from": from,
          if (to != null) "to": to,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Failed to fetch emotion history";
    }
  }

  static Future<Map<String, dynamic>> getEmotionReport({
    String groupBy = "daily",
    String? from,
    String? to,
  }) async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.emotionReport,
        queryParameters: {
          "groupBy": groupBy,
          if (from != null) "from": from,
          if (to != null) "to": to,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw e.response?.data["message"] ?? "Failed to fetch emotion report";
    }
  }
}
