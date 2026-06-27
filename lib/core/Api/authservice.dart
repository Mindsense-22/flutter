import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/features/login/modules/loginresponse_model.dart';
import 'package:mindsense_app/features/sign%20up/modules/verifypincoderesponse.dart';

class AuthService {
  static String apiMessege="";


  static Future<void> signUp({
  required String name,
  required String email,
  required String password,
  required String passwordConfirm,
  required int age,
  required String role,
  File? image, // optional
}) async {
  try {
    final formDataMap = {
      "name": name,
      "email": email,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "age": age,
      "role": role,
    };

    if (image != null) {
      formDataMap["profileImage"] = await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      );
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await DioFactory.postFormData(
      path: ApiConstants.signup,
      data: formData,
    );

    log("SUCCESS: ${response.data}");
  } catch (e) {
    rethrow;
  }
}

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

  static Future<void> resendSignUpPinCode(String email) async {
    await DioFactory.postData(
      path: ApiConstants.resendCode,
      data: {"email": email},
    );
  }

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

  static Future<Map<String, dynamic>> updateMe(String? name, String? email, int? age,File ?profileImage) async {
    try {
      Map<String, dynamic> data = {};
      if (name != null) data["name"] = name;
      if (email != null) data["email"] = email;
      if (age != null) data["age"] = age;

      if (profileImage != null) {
        data["profileImage"] = await MultipartFile.fromFile(
          profileImage.path,
          filename: profileImage.path.split(Platform.pathSeparator).last,
        );
        final formData = FormData.fromMap(data);
        final response = await DioFactory.patchFormData(
          path: ApiConstants.updateMe,
          data: formData,
        );
        return response.data["data"]["user"];
      }

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

  static Future<String> uploadAvatar(File imageFile) async {
    try {
      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
      });

      final response = await DioFactory.postFormData(
        path: ApiConstants.uploadAvatar,
        data: formData,
      );
      log(response.data.runtimeType.toString());
      log(response.data.toString());
      return response.data["data"]["profileImage"] ;
    } on DioException catch (e) {
      log("Error Data: ${e.response?.data}");
      log("Error Type: ${e.response?.data.runtimeType}");

      throw e.response?.data.toString() ?? "Failed to upload avatar";
    }
  }
  static Future<bool> deleteAccount({required String password, required String reason, String mode = 'soft'}) async {
    try {
      final response = await DioFactory.deleteData(
        path: ApiConstants.deleteMe,
        data: {'password': password, 'reason': reason},
        queryParameters: {'mode': mode},
      );
      return response.data['success'] == true;
    } on DioException catch (e) {
        log("STATUS: ${e.response?.statusCode}");
        log("DATA TYPE: ${e.response?.data.runtimeType}");
        log("DATA: ${e.response?.data}");
      final message = e.response?.data['message'] ?? 'Failed to delete account';
      throw message;
    }
  }
}


