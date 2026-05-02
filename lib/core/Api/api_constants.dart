class ApiConstants {
  static const String baseUrl = "http://10.0.2.2:5020";

  static const String signup = "/api/v1/users/signup";
  static const String login = "/api/v1/users/login";
  static const String verify = "/api/v1/users/verify";
  static const String resendCode = "/api/v1/users/resendCode";
  
  static const String forgotPassword = "/api/v1/users/forgotPassword";
  static const String verifyResetCode = "/api/v1/users/verifyResetCode";
  static const String resetPassword = "/api/v1/users/resetPassword";
  
  static const String getMe = "/api/v1/users/me";
  static const String updateMe = "/api/v1/users/updateMe";
  static const String updateMyPassword = "/api/v1/users/updateMyPassword";

  static const String analyzeFace = "/api/emotion/face";
  static const String analyzeVoice = "/api/emotion/voice";
  static const String analyzeAll = "/api/emotion/all";
  static const String emotionHistory = "/api/emotion/history";
  static const String emotionReport = "/api/emotion/report";
  static const String approveContact = "/api/v1/users/approve-contact/";
  static const String addContact = "/api/v1/users/add-contact";
}