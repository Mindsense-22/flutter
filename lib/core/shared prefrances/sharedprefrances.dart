import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesitem {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> setBool(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  static Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  static String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    await sharedPreferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }
  
  static Future<void> setDouble(String key, double value) async {
    await sharedPreferences.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return sharedPreferences.getDouble(key);
  }

  static Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  static Future<void> clear() async {
    await sharedPreferences.clear();
  }

}