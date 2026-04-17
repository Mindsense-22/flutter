import 'package:flutter/material.dart';

class Homescreenprovider extends ChangeNotifier {
  int selectedIndex = -1;
  String imogistatus="";

  final  List<Map<String, String>> emojis = [    
    {"emojiPath": "assets/images/happy_imogi.svg", "label": "Happy"},
    {"emojiPath": "assets/images/sad_imogi.svg", "label": "Sad"},
    {"emojiPath": "assets/images/stress_imogi.svg", "label": "Stress"},
    {"emojiPath": "assets/images/love_imogi.svg", "label": "Love"},
    {"emojiPath": "assets/images/angry_imogi.svg", "label": "Angry"},
  ];
  changeImogiStatus(status){
    imogistatus=status;
    notifyListeners();
  }
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}