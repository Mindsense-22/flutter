import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/core/modules/user.dart';
import 'package:mindsense_app/features/login/modules/loginresponse_model.dart';
import 'package:mindsense_app/features/sign%20up/modules/verifypincoderesponse.dart';

class AuthService {
  static String apiMessege="";
  // signup
  static Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
    required int age,
    required String role,
  }) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.signup,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "passwordConfirm": passwordConfirm,
          "age": age,
          "role":role,
        },        
      );

      log("SUCCESS: ${response.data}");
      
    } catch (e) {
      if (e is DioException) {
        log("STATUS: ${e.response?.statusCode}");
        log("DATA: ${e.response?.data}");
        apiMessege = e.response?.data["message"];
      }
      rethrow;
    }
  }

  //verifyPinCode
  static Future<VerifyPinCodeResponse> verifyPinCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.verify,
        data: {
          "email": email,
          "code": code,
        },
      );

      return VerifyPinCodeResponse.fromJson(response.data);

    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Verify failed";
      throw message;
    }
  }

  // ================= RESENDSignUpPinCode =================
  static Future<void> resendSignUpPinCode(String email) async {
    await DioFactory.postData(
      path: ApiConstants.resendCode,
      data: {"email": email},
    );
  }

  //////// login auth//////////////////////////////////
  
  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.login,
        data: {
          "email": email,
          "password": password,
        },
      );
      
      return LoginResponse.fromJson(response.data);

    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Login failed";
      throw message;
    }
  }












  static Future<void> forgotPassword(String email) async {
    try {
      await DioFactory.postData(
        path: ApiConstants.forgotPassword,
        data: {"email": email},
      );
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to request password reset";
      throw message;
    }
  }

  static Future<void> verifyResetCode(String email, String code) async {
    try {
      await DioFactory.postData(
        path: ApiConstants.verifyResetCode,
        data: {"email": email, "code": code},
      );
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Invalid code";
      throw message;
    }
  }

  static Future<String> resetPassword(String email, String code, String newPassword) async {
    try {
      final response = await DioFactory.patchData(
        path: ApiConstants.resetPassword,
        data: {"email": email, "code": code, "newPassword": newPassword},
      );
      return response.data["token"];
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to reset password";
      throw message;
    }
  }

  static Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await DioFactory.getData(
        path: ApiConstants.getMe,
      );
      return response.data["data"]["user"];
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to get profile";
      throw message;
    }
  }

  static Future<Map<String, dynamic>> updateMe(String? name, String? email, int? age) async {
    try {
      Map<String, dynamic> data = {};
      if (name != null) data["name"] = name;
      if (email != null) data["email"] = email;
      if (age != null) data["age"] = age;
      
      final response = await DioFactory.patchData(
        path: ApiConstants.updateMe,
        data: data,
      );
      return response.data["data"]["user"];
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to update profile";
      throw message;
    }
  }

  static Future<String> updateMyPassword(String passwordCurrent, String password, String passwordConfirm) async {
    try {
      final response = await DioFactory.patchData(
        path: ApiConstants.updateMyPassword,
        data: {
          "passwordCurrent": passwordCurrent,
          "password": password,
          "passwordConfirm": passwordConfirm,
        },
      );
      return response.data["token"];
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to update password";
      throw message;
    }
  }

  static Future<void> approveContact(String token) async {
    try {
      await DioFactory.getData(
        path: "${ApiConstants.approveContact}$token",
      );
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to approve contact";
      throw message;
    }
  }

  static Future<Map<String, dynamic>> addContact({
    required String contactName,
    required String contactEmail,
    required String relationship,
  }) async {
    try {
      final response = await DioFactory.postData(
        path: ApiConstants.addContact,
        data: {
          "contactName": contactName,
          "contactEmail": contactEmail,
          "relationship": relationship,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to add contact";
      throw message;
    }
  }
}

