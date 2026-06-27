import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/widgets/camerapermissiondialog_wid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


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



}