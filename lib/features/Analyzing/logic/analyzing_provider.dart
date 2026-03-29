import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnalyzingProvider extends ChangeNotifier {
  XFile ?selctedimage;
  
  setSelectedImage(image){
    selctedimage=image;
    notifyListeners();
  }
  
  
}