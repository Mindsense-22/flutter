import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:path_provider/path_provider.dart';


class ProfileScreenProvider extends ChangeNotifier {
  ProfileScreenProvider(){
    loadProfileImage();
    fetchUserProfile();
  }
  Future<void> init() async {
    await loadProfileImage();
    await fetchUserProfile();
  }
  
  bool isDarkMode = true;
  File ?profileImage;
  String ? profileImagePath;
  
  String? userName;
  String? userEmail;
  int? userAge;
  bool isLoadingProfile = false;
  setName(newname){
    userName=newname;
    notifyListeners();
  }
  setEmail(newemail){
    userEmail=newemail;
    notifyListeners();
  }
  setAge(newage){
    userAge=newage;
    notifyListeners();
  }
  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile = true;
      notifyListeners();
      
      final userData = await AuthService.getMe();
      userName = userData['name'];
      userEmail = userData['email'];
      userAge = userData['age'];
      if(userName!=null){
        await SharedPreferencesitem.setString("userName", userName!);
        setName(userName);
      }
      if(userEmail!=null){
        await SharedPreferencesitem.setString("userEmail", userEmail!);
        setEmail(userEmail);
      }
      if(userAge!=null){
        await SharedPreferencesitem.setInt("userAge", userAge!);
        setAge(userAge);
      }
      
      
      isLoadingProfile = false;
      notifyListeners();
    } catch (e) {
      isLoadingProfile = false;
      notifyListeners();
      log("Error fetching profile: $e");
    }
  }

  Future<void> updateUserProfile({required  String? name, required String? email,required  int? age}) async {
    try {
      isLoadingProfile = true;
      notifyListeners();
      
      final updatedData = await AuthService.updateMe(name, email, age);
      if (updatedData['name'] != null){userName = updatedData['name'];notifyListeners();} 
      if (updatedData['email'] != null){userEmail = updatedData['email'];notifyListeners();} 
      if (updatedData['age'] != null){userAge = updatedData['age'];notifyListeners();} 
      if(userName!=null){
        await SharedPreferencesitem.setString("userName", userName!);
      }
      if(userEmail!=null){
        await SharedPreferencesitem.setString("userEmail", userEmail!);
      }
      if(userAge!=null){
        await SharedPreferencesitem.setInt("userAge", userAge!);
      }
      
      isLoadingProfile = false;
      notifyListeners();
    } catch (e) {
      isLoadingProfile = false;
      notifyListeners();
      log("Error updating profile: $e");
      rethrow;
    }
  }
  
  Future<void> updateUserPassword({required String currentPassword, required String newPassword, required String confirmPassword}) async {
    try {
      isLoadingProfile = true;
      notifyListeners();
      
      final newToken = await AuthService.updateMyPassword(currentPassword, newPassword, confirmPassword);
      await SharedPreferencesitem.setString("token", newToken);
      
      isLoadingProfile = false;
      notifyListeners();
    } catch (e) {
      isLoadingProfile = false;
      notifyListeners();
      log("Error updating password: $e");
      rethrow;
    }
  }  
  

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
