import 'package:flutter/material.dart';

class PhotoAnalysisProvider extends ChangeNotifier{
  bool cameraPermissionAllowed=false;

  changeCameraPermission(bool permission){
    cameraPermissionAllowed=permission;
    notifyListeners();
  }
}