import 'package:flutter/material.dart';

class Homescreenprovider extends ChangeNotifier {
  int selectedIndex = -1;

  final  List<Map<String, String>> emojis = [
    {"emoji": "😀", "label": "Happy"},
    {"emoji": "😔", "label": "Sad"},
    {"emoji": "😫", "label": "Stress"},
    {"emoji": "😍", "label": "Love"},
    {"emoji": "😡", "label": "Angry"},
  ];

  void changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}