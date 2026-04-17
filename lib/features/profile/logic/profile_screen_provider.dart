import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreenProvider extends ChangeNotifier {
  ProfileScreenProvider(){
    loadProfileImage();
  }
  
  bool isDarkMode = true;
  File ?profileImage;
  String ? profileImagePath;

  Future<void> pickGalleryImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final savedImage = await File(pickedImage.path).copy(newPath);

      profileImage = savedImage;
      profileImagePath = newPath;
      await SharedPreferencesitem.setString("profileImagePath",profileImagePath!);
      notifyListeners();
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<void> loadProfileImage() async {  
  final path = SharedPreferencesitem.getString("profileImagePath");

  if (path != null && path.isNotEmpty) {
    profileImagePath = path;
    profileImage = File(path);
    notifyListeners();
  }
}
  

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }
}
