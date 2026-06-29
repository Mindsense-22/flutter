import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';
import 'package:mindsense_app/core/Api/intervention_service.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';

class Homescreenprovider extends ChangeNotifier {
  int selectedIndex = -1;
  String imogistatus="";

  int totalScans=0;
  String currentstate="";
  double confidence=0;
  Map emotionHistory = {};
  Map ? interventionData;
  
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
  // intervention
  List returnedExercises=[];
  List showedExercises=[];
  Future<void> fetchIntervention({
    String ? state,
    String ? goal,
    String ? context,
    String ? language,
  }) async {   
    try {
      String userState=SharedPreferencesitem.getString("currentstate_home")??"Stressed";
      final response = await InterventionService.postIntervention(
        state: userState,
        goal: "Relax",
        context: "Work deadline",
        language: "en",
      );
      
      if (response['status'] == 'success') {
        interventionData = response;
        returnedExercises=interventionData!["advice"]["content"]["en"]["goals"]["calm"]["plan"]??[];
        if(returnedExercises!=[]){
          // for(int i=0;i<returnedExercises.length;i++){
          //  await  SharedPreferencesitem.setString("returnedExercisesnum$i", returnedExercises[i]);
          // }
          // for(int i=0;i<returnedExercises.length;i++){
          //   showedExercises.add(SharedPreferencesitem.getString("returnedExercisesnum$i")!);
            
          // }
          showedExercises=returnedExercises;
          notifyListeners();

        }
      }
    } catch (e) {
      log(e.toString());
    } finally {
      
      notifyListeners();
    }
  }
   
}