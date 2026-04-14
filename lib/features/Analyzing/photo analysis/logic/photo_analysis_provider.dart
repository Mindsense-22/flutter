import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/photo_scan_result_screen.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/widgets/camerapermissiondialog_wid.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoAnalysisProvider extends ChangeNotifier{
  bool cameraPermissionAllowed=SharedPreferencesitem.getBool("cameraPermissionAllowed") ??false;
  XFile ?selctedimage;

  clearSelectedImage(){
    selctedimage=null;
    notifyListeners();
  }
  pickGalleryImage()async{
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );
    selctedimage=image;
    image=null;
    notifyListeners();
    AnalyzingProvider().setSelectedImage(image);
  }

  pickCameraImage()async{
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      await Permission.camera.request();
      openAppSettings();
    }
    if (status.isGranted) {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );

      selctedimage = image;

      notifyListeners();

      AnalyzingProvider().setSelectedImage(image);
    } else {
      log("Camera permission denied");
    }
  }

  changeCameraPermission(bool permission){    
    SharedPreferencesitem.setBool("cameraPermissionAllowed",permission);
    cameraPermissionAllowed=SharedPreferencesitem.getBool("cameraPermissionAllowed") ??false;  
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