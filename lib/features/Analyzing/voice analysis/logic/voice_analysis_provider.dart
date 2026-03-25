
import 'package:flutter/material.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/widgets/voicepermissiondialog_wid.dart';

class VoiceAnalysisProvider extends ChangeNotifier{
  bool voicePermissionAllowed=false;

  changeVoicePermission(bool permission){
    voicePermissionAllowed=permission;
    notifyListeners();
  }

  Future<dynamic>voicePermissionShowDialog(context){
    return showDialog(
      context: context,
      builder: (context) {
        return VoicepermissiondialogWid();
      }
    );  
  }

}