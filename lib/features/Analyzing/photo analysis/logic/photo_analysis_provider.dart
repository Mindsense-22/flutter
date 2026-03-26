import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/photo_scan_result_screen.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/widgets/camerapermissiondialog_wid.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoAnalysisProvider extends ChangeNotifier{
  bool cameraPermissionAllowed=false;

  changeCameraPermission(bool permission){
    cameraPermissionAllowed=permission;
    notifyListeners();
  }

  // Future<void> requestCameraPermission( context) async {
  //   var status = await Permission.camera.request();
    
  //   if (status.isGranted) {
  //     changeCameraPermission(true);
  //     // ✅ اتوافق
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => PhotoScanResultScreen()),
  //     );
  //   } else if (status.isDenied) {
  //     // ❌ اترفض
  //     showDialog(
  //       context: context,
  //       builder: (_) => CamerapermissiondialogWid(),
  //     );
  //   } else if (status.isPermanentlyDenied) {
  //     // ❌ اترفض نهائي (Don't ask again)
  //     openAppSettings();
  //   }
  //   else if (status.isLimited) {
  //     changeCameraPermission(true);
  //   }
  // }

  Future<dynamic>cameraPermissionShowDialog(context){
    return showDialog(
      context: context,      
      builder: (context) {
        return CamerapermissiondialogWid();
      }
    );  
  }

}