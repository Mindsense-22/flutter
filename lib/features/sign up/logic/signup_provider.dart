import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';

import 'package:mindsense_app/features/sign%20up/ui/signup_setpincode_screen.dart';
import 'package:path_provider/path_provider.dart';

class SignupProvider extends ChangeNotifier{

  TextEditingController signupPasswordController=TextEditingController();
  TextEditingController signupReEnterPasswordController=TextEditingController();
  TextEditingController signupNameController=TextEditingController();
  TextEditingController signupEmailController=TextEditingController();
  TextEditingController signupAgeController=TextEditingController();
  final formKey = GlobalKey<FormState>();
  String userRole="user";
  bool signupbuttonisloading=false;
  bool checkBoxVal=false;
  File? profileImage;
  String ?signUpPhotoPath;
  void changeSignupButtonIsLoading(val) {
    signupbuttonisloading = val;
    notifyListeners();
  }
  
  String ? ageValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if (int.parse(val) <7) {
      return "Age must be 7 or greater";
    }
    return null;
  }

  String ? emailValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if (!val.endsWith("@gmail.com")) {
      return "Email must end with @gmail.com";
    }
    
    
    return null;
  }

  String ? nameValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if(val.length<2){
      return "Name Must Be Two Characters Or More";
    }
    return null;
  }


  String? passwordValidator(String? val) {
    if (val == null || val.isEmpty) {
      return "Fill the field";
    }

    if (val.length < 8) {
      return "At least 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(val)) {
      return "Must contain uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(val)) {
      return "Must contain lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(val)) {
      return "Must contain number";
    }

    // ✅ يحتوي على واحد من المسموح فقط
    if (!RegExp(r'[@$!%*?&]').hasMatch(val)) {
      return "Must contain one special char (@\$!%*?&)";
    }

    // ❌ يمنع أي special character تاني
    if (RegExp(r'[^a-zA-Z0-9@$!%*?&]').hasMatch(val)) {
      return "Only allowed special chars are (@\$!%*?&)";
    }

    return null;
  }

  String ? reEnterpasswordValidator(String ? val){
    if(val==null||val.isEmpty){
    return "fill The Field";                          
    }      
    if(signupReEnterPasswordController.text!=signupPasswordController.text){
      return "Passwords Does not Match ";
    } 
    return null;
  }
  
  void setUserRole(role){
    userRole=role;
    changeCheckBoxVal();
    notifyListeners();
  }
  void changeCheckBoxVal(){
    checkBoxVal=!checkBoxVal;
    notifyListeners();
  }

  Future<void> pickGalleryImage(context) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) return;

      final directory = await getApplicationDocumentsDirectory();

      final newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final savedImage = await File(
        pickedImage.path,
      ).copy(newPath);
      profileImage=savedImage;
      signUpPhotoPath = savedImage.path;

      notifyListeners();
    } catch (e, s) {
      log('Error picking image: $e');
      log('StackTrace: $s');
      if (!context.mounted) return;
      customSnackbar(context,true,"Something went wrong");
     
    }
  }

  Future<void> signupButton(context) async {
    if (formKey.currentState!.validate()) {
      changeSignupButtonIsLoading(true);
      log("Form is valid");
      
      try {       
        await AuthService.signUp(
          name: signupNameController.text,
          email: signupEmailController.text,
          password: signupPasswordController.text,
          passwordConfirm: signupReEnterPasswordController.text,
          age: int.parse(signupAgeController.text),
          role:userRole, image: profileImage,
        );

        await SharedPreferencesitem.setString(
          "userEmail",
          signupEmailController.text,
        );
        if (!context.mounted) return;
        customSnackbar(context,false,"Pin Code sent To your Email");
        

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupSetpincodeScreen(
              context: context,
            ),
          ),
        );
        changeSignupButtonIsLoading(false);
      } catch (e, s) {
        log("Signup failed");
        log("Error: $e");
        log("StackTrace: $s");
        changeSignupButtonIsLoading(false);
        if (!context.mounted) return;
        customSnackbar(context,true,"Signup failed");
       
      }

    } else {
      log("Form is NOT valid");
      if (!context.mounted) return;
      customSnackbar(context,true,"Form Is NOT Valid");
      
    }
  }

  void resetProvider() {
    signupPasswordController.clear();
    signupReEnterPasswordController.clear();
    signupNameController.clear();
    signupEmailController.clear();
    signupAgeController.clear();
    userRole = "user";
    signupbuttonisloading = false;
    checkBoxVal = false;
    profileImage = null;
    signUpPhotoPath = null;
    notifyListeners();
  }
}