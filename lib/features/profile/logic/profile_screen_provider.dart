import 'package:flutter/material.dart';

class ProfileScreenProvider extends ChangeNotifier {
  bool isDarkMode = true;

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }
}