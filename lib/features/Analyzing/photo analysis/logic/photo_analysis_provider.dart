import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/Api/emotion_service.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/photo_scan_result_screen.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/widgets/camerapermissiondialog_wid.dart';
import 'package:mindsense_app/features/Analyzing/report/logic/analysisreportprovider.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class PhotoAnalysisProvider extends ChangeNotifier{
  double targetvalue=0.0;
  String stateCondition="Neutral";
  bool cameraPermissionAllowed=SharedPreferencesitem.getBool("cameraPermissionAllowed") ??false;
  XFile ?selctedimage;
  bool isloading = false;

  void changeIsLoading(bool val) {
    isloading = val;
    notifyListeners();
  }

  List<String> imageAnalysisExercises= [
     'Take slow deep breaths to help your body relax',
     'Gently stretch your neck and shoulders to release tension',
     'Close your eyes for a moment to give them a quick rest',     
  ];

  clearSelectedImage(){
    selctedimage=null;
    notifyListeners();
  }

  pickGalleryImage(context)async{
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 800,
      maxHeight: 800,
    );
    selctedimage=image;
    Provider.of<AnalyzingProvider>(context, listen: false)
    .setSelectedImage(image);
    image=null;
    notifyListeners();
  }

  pickCameraImage(context)async{
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
      openAppSettings();
    }
    if (status.isGranted) {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
      maxWidth: 800,
      maxHeight: 800,
    );
      selctedimage = image;
      Provider.of<AnalyzingProvider>(context, listen: false)
      .setSelectedImage(image);
      notifyListeners();
    } else {
      log("Camera permission denied");
    }
  }

  changeCameraPermission(bool permission){    
    SharedPreferencesitem.setBool("cameraPermissionAllowed",permission);
    cameraPermissionAllowed=SharedPreferencesitem.getBool("cameraPermissionAllowed") ??false;  
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

  // Future<void> analyzeFace(BuildContext context) async {
  //   if (selctedimage == null) return;

  //   changeIsLoading(true);
  //   try {
  //     final result = await EmotionService.analyzeFace(File(selctedimage!.path));
      
  //     // Update state based on API response
  //     stateCondition = result["analysis"]?["state"] ?? result["emotion"]?["state"] ?? "Neutral";
      
  //     var scores = result["analysis"]?["scores"];
  //     if (scores != null && scores[stateCondition] != null) {
  //       targetvalue = (scores[stateCondition] as num).toDouble();
  //     } else {
  //       targetvalue = (result["emotion"]?["confidence"] as num?)?.toDouble() ?? 0.0;
  //     }

  //     // Also update Analysisreportprovider
  //     Provider.of<Analysisreportprovider>(context, listen: false).updateImageResults(targetvalue, stateCondition);

  //     // Also update AnalyzingProvider if it's used elsewhere
  //     final analyzingProvider = Provider.of<AnalyzingProvider>(context, listen: false);
  //     analyzingProvider.setSelectedImage(selctedimage);
  //     analyzingProvider.detectedEmotion = stateCondition;
  //     analyzingProvider.aiAdvice = result["advice"];
  //     analyzingProvider.emotionScores = result["analysis"]?["scores"];
      
  //     changeIsLoading(false);
      
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => PhotoScanResultScreen()),
  //     );
  //   } catch (e) {
  //     changeIsLoading(false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(e.toString()),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

}