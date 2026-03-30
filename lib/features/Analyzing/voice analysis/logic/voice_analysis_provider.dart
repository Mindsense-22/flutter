
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/widgets/voicepermissiondialog_wid.dart';

class VoiceAnalysisProvider extends ChangeNotifier{
  bool voicePermissionAllowed=false;
  bool isRecording=false;

  int recordTime=0;  
  Timer? timer;

  Future<dynamic>voicePermissionShowDialog(context){
    return showDialog(
      context: context,
      builder: (context) {
        return VoicepermissiondialogWid();
      }
    );  
  }

  changeVoicePermission(bool permission){
    voicePermissionAllowed=permission;
    notifyListeners();
  }

  changeIsRecording() {
    isRecording = !isRecording;
    if(isRecording){
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        recordTime ++; 
        notifyListeners();
      });
    }
    else{
      timer?.cancel();
      isRecording = false;
      notifyListeners();
    }    
  }
  
  
  cancelRecording() {
    timer?.cancel();
    isRecording = false;
    recordTime = 0;
    notifyListeners();
  }
 
  // time formt for display
  String formatTime(int time) {
    int minutes = time ~/ 60;
    int seconds = time % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return "${twoDigits(minutes)}:${twoDigits(seconds)}";
  }
  
  

}