
import 'package:mindsense_app/core/modules/user.dart';

class VerifyPinCodeResponse {
  final String status;
  final String token;
  final User user;

  VerifyPinCodeResponse({
    required this.status,
    required this.token,
    required this.user,
  });

  factory VerifyPinCodeResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPinCodeResponse(
      status: json["status"],
      token: json["token"],
      user: User.fromJson(json["data"]["user"]),
    );
  }
}