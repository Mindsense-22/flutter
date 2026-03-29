import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnalyzingProvider extends ChangeNotifier {
  XFile ?selctedimage;

  pickGalleryImage()async{
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    selctedimage=image;
    notifyListeners();
  }

  pickCameraImage()async{
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    selctedimage=image;
    notifyListeners();
  }
  
}