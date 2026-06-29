import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';

class Homescreenprovider extends ChangeNotifier {
  int selectedIndex = -1;
  String imogistatus="";

  int totalScans=0;
  String currentstate="";
  double confidence=0;
  Map emotionHistory = {};
  
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

  // get emotion history
  Future<void> fetchEmotionHistory({
    int? limit,
    String? source,
    String? from,
    String? to,
  }) async {   
    try {
      final response = await EmotionService.getEmotionHistory(
        limit: 1000,
        source: null,
        from: null,
        to: null,
      );

      if (response['status'] == 'success') {
        emotionHistory = response ;
        totalScans=emotionHistory["results"]??0;
        currentstate=emotionHistory["data"][0]["state"]??"";
        confidence=emotionHistory["data"][0]["confidence"]??0;
        await SharedPreferencesitem.setString("currentstate_home", currentstate);
        await SharedPreferencesitem.setInt("totalScans_home", totalScans);
        await SharedPreferencesitem.setDouble("confidence_home", confidence);
        
      } else {
        
      }
    } catch (e) {
      log(e.toString());
    } finally {
      
      notifyListeners();
    }
  }
   
}