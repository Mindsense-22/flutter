import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/widgets/camerapermissiondialog_wid.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';

class PhotoAnalysisProvider extends ChangeNotifier{
  bool cameraPermissionAllowed=false;

  changeCameraPermission(bool permission){
    cameraPermissionAllowed=permission;
    notifyListeners();
  }

  Future<dynamic>cameraPermissionShowDialog(context){
    return showDialog(
      context: context,
      builder: (context) {
        return CamerapermissiondialogWid();
      }
    );  
  }

}