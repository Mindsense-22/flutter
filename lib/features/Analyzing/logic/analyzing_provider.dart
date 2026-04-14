import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnalyzingProvider extends ChangeNotifier {
  XFile ?selctedimage;
  File ? selectedaudio;
  
  setSelectedImage(image){
    selctedimage=image;
    notifyListeners();
  }

  setSelectedAudio(audio){
    selectedaudio=audio;
    notifyListeners();
  }
  
  
}