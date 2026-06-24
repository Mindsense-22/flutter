import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';

class VoiceChatService {
  static String apiMessage = "";

  static Future<Map<String, dynamic>> getSettings() async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.voiceSettings,
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to get settings";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> updateSettings({
    String? preferredLanguage,
    bool? autoDetect,
    String? voiceStyle,
    num? speed,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (preferredLanguage != null) data["preferredLanguage"] = preferredLanguage;
      if (autoDetect != null) data["autoDetect"] = autoDetect;
      if (voiceStyle != null) data["voiceStyle"] = voiceStyle;
      if (speed != null) data["speed"] = speed;

      final response = await DioFactory.patchData(
        path: ApiConstants.voiceSettings,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to update settings";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> previewSettings({
    required String preferredLanguage,
    required String voiceStyle,
    required num speed,
  }) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.voiceSettingsPreview,
        data: {
          "preferredLanguage": preferredLanguage,
          "voiceStyle": voiceStyle,
          "speed": speed,
        },
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to preview settings";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> startSession({String? emotion}) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.voiceSessionStart,
        data: {
          if (emotion != null) "emotion": emotion,
        },
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to start session";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String sessionId,
    required File audioFile,
    String? emotion,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "sessionId": sessionId,
        if (emotion != null) "emotion": emotion,
        "audio": await MultipartFile.fromFile(audioFile.path, filename: "message.wav"),
      });

      final response = await DioFactory.postFormData(
        path: ApiConstants.voiceSessionMessage,
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to send message";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> endSession({required String sessionId}) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.voiceSessionEnd,
        data: {
          "sessionId": sessionId,
        },
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to end session";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> getHistory({int? limit}) async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.voiceHistory,
        queryParameters: {
          if (limit != null) "limit": limit,
        },
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to get history";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> checkSubscription() async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.voiceSubscriptionCheck,
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to check subscription";
      throw apiMessage;
    }
  }

  static Future<Map<String, dynamic>> resetSubscription() async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.voiceSubscriptionReset,
        data: {},
      );
      return response.data;
    } on DioException catch (e) {
      apiMessage = e.response?.data["message"] ?? "Failed to reset subscription";
      throw apiMessage;
    }
  }
}