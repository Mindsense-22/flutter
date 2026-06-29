import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
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
  String ?userId;
  String ? userRole;
  String ? trustedContactname;
  String ? trustedContactemail;
  String ? trustedContactrelationship;
  String ? trustedContactstatus;
  bool photoLoading=false;
  bool isLoadingProfile = false;
  String ? avatarLink;
  List followingIds=[];
  List following=[];
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
  setID(id){
    userId=id;
    notifyListeners();
  }
  
  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile = true;
      notifyListeners();
      
      final userData = await AuthService.getMe();
      userName = userData['name'];
      userEmail = userData['email'];
      userId= userData['_id'];
      userAge = userData['age'];
      profileImagePath=userData["profileImage"];
      userRole=userData["role"];
      following=userData["following"];
      final trustedContact = userData["trustedContact"];
      if (trustedContact != null) {
        trustedContactname = trustedContact["name"];
        trustedContactemail = trustedContact["email"];
        trustedContactrelationship = trustedContact["relationship"];
        trustedContactstatus = trustedContact["status"];
      }
      followingIds.clear();
      if(following.isNotEmpty){
        for(int i=0;i<following.length;i++){
          followingIds.add(following[i]["_id"]);
        }        
      }
      avatarLink=userData["profileImage"]; 
      notifyListeners();     
      if (avatarLink != null &&
          avatarLink is String &&
          avatarLink!.isNotEmpty) {

        await SharedPreferencesitem.setString(
          "avatarLink",
          profileImagePath!,
        );

        notifyListeners();
      }else {
        // optional fallback
        await SharedPreferencesitem.remove("avatarLink");
        notifyListeners();
      }
      if(userName!=null){
        await SharedPreferencesitem.setString("userName", userName!);
        setName(userName);
      }
      if(userRole!=null){
        await SharedPreferencesitem.setString("userRole", userRole!);        
      }
      if(userEmail!=null){
        await SharedPreferencesitem.setString("userEmail", userEmail!);
        setEmail(userEmail);
      }
      if(userAge!=null){
        await SharedPreferencesitem.setInt("userAge", userAge!);
        setAge(userAge);
      }
      if(userId!=null){
        await SharedPreferencesitem.setString("userId", userId!);
        setID(userId);
      }
      // store trusted contact
      if(trustedContactname!=null){
        await SharedPreferencesitem.setString("trustedContactname", trustedContactname!);
        
      }
      if(trustedContactemail!=null){
        await SharedPreferencesitem.setString("trustedContactemail", trustedContactemail!);
       
      }
      if(trustedContactrelationship!=null){
        await SharedPreferencesitem.setString("trustedContactrelationship", trustedContactrelationship!);
       
      }
      if(trustedContactstatus!=null){
        await SharedPreferencesitem.setString("trustedContactstatus", trustedContactstatus!);
        
      }  
    } catch (e) {
      log("Error fetching profile: $e");
    }
  }

  void addFollowingOptimistic(String id) {
    if (!followingIds.contains(id)) followingIds.add(id);
    notifyListeners();
  }

  void removeFollowingOptimistic(String id) {
    followingIds.remove(id);
    notifyListeners();
  }

  Future updateUserProfile({required  String? name, required String? email,required  int? age,required File ?image}) async {
    try {
      isLoadingProfile = true;
      notifyListeners();      
      final updatedData = await AuthService.updateMe(name, email, age,image);
      if (updatedData['name'] != null){userName = updatedData['name'];notifyListeners();} 
      if (updatedData['email'] != null){userEmail = updatedData['email'];notifyListeners();} 
      if (updatedData['age'] != null){userAge = updatedData['age'];notifyListeners();} 
      if (updatedData['profileImage'] != null){profileImagePath = updatedData['profileImage'];notifyListeners();}
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
      return updatedData;
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
  

  Future<void> pickGalleryImage(context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) return;

      final directory = await getApplicationDocumentsDirectory();

      final newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.PNG';

      // COPY THE FILE
      final File newImage = await File(pickedImage.path).copy(newPath);

      profileImagePath = newImage.path;
      photoLoading=true;
      notifyListeners();      
      
      String userName=SharedPreferencesitem.getString("userName")!;
      String userEmail=SharedPreferencesitem.getString("userEmail")!;
      int userAge=SharedPreferencesitem.getInt("userAge")!;
      var data =await updateUserProfile(image: File(profileImagePath!),age: userAge,email: userEmail,name: userName);     
      // Evict old cached image so CachedNetworkImage fetches the new one
      final oldAvatarLink = avatarLink;
      if (oldAvatarLink != null && oldAvatarLink.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(ApiConstants.baseUrl + oldAvatarLink);
      }
      avatarLink = data["profileImage"];
      if (avatarLink != null && avatarLink!.isNotEmpty) {
        await CachedNetworkImage.evictFromCache(ApiConstants.baseUrl + avatarLink!);
      }
      await SharedPreferencesitem.setString("avatarLink",avatarLink!);
      photoLoading=false;
      loadProfileImage();
      notifyListeners();
    } catch (e, s) {
      log('Error picking image: $e');
      log('StackTrace: $s');
      customSnackbar(context,true,"Something went wrong,try again");
      
    }
  }

  Future<void> loadProfileImage() async {  
    final path =  SharedPreferencesitem.getString("avatarLink");

    if (path != null && path.isNotEmpty) {
      avatarLink = path;
      notifyListeners();
    }
  }
  

  void toggleDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  bool isApprovingContact = false;
  Future<void> approveContact(String token) async {
    try {
      isApprovingContact = true;
      notifyListeners();

      await AuthService.approveContact(token);

      isApprovingContact = false;
      notifyListeners();
    } catch (e) {
      isApprovingContact = false;
      notifyListeners();
      log("Error approving contact: $e");
      rethrow;
    }
  }

  bool isAddingContact = false;
  Future<void> addContact({
    required String contactName,
    required String contactEmail,
    required String relationship,
  }) async {
    try {
      isAddingContact = true;
      notifyListeners();

      await AuthService.addContact(
        contactName: contactName,
        contactEmail: contactEmail,
        relationship: relationship,
      );

      isAddingContact = false;
      notifyListeners();
    } catch (e) {
      isAddingContact = false;
      notifyListeners();
      log("Error adding contact: $e");
      rethrow;
    }
  }
  
  Future<void> deleteAccount({required String password, required String reason, String mode = 'soft'}) async {
    try {
      isLoadingProfile = true;
      notifyListeners();
      bool success = await AuthService.deleteAccount(password: password, reason: reason, mode: mode);
      if (success) {
        // Clear stored user data
        await SharedPreferencesitem.clear();
        // Reset provider fields
        profileImage = null;
        profileImagePath = null;
        userName = null;
        userEmail = null;
        userAge = null;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    } finally {
      isLoadingProfile = false;
      notifyListeners();
    }
  
}
void resetProvider() {
    isDarkMode = true;
    profileImage = null;
    profileImagePath = null;
    userName = null;
    userEmail = null;
    userAge = null;
    userId = null;
    userRole = null;
    trustedContactname = null;
    trustedContactemail = null;
    trustedContactrelationship = null;
    trustedContactstatus = null;
    photoLoading = false;
    isLoadingProfile = false;
    avatarLink = null;
    followingIds.clear();
    following.clear();
    notifyListeners();
  }
}

