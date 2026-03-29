import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnalyzingProvider extends ChangeNotifier {
  XFile ?selctedimage;

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
  }

  pickCameraImage()async{
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );
    selctedimage=image;
    image=null;
    notifyListeners();
  }
  
}