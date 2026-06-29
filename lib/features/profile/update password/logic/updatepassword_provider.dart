import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';

class UpdatepasswordProvider extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController=TextEditingController();
  TextEditingController newPasswordController=TextEditingController();
  TextEditingController reEnterNewPasswordController=TextEditingController();
  bool updatePasswordisloading=false;
  
  
  void changeUpdatePasswordIsLoading(val) {
    updatePasswordisloading = val;
    notifyListeners();
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


    if (!RegExp(r'[@$!%*?&]').hasMatch(val)) {
      return "Must contain one special char (@\$!%*?&)";
    }


    if (RegExp(r'[^a-zA-Z0-9@$!%*?&]').hasMatch(val)) {
      return "Only allowed special chars are (@\$!%*?&)";
    }

    return null;
  }

  String ? reEnterpasswordValidator(String ? val){
    if(val==null||val.isEmpty){
    return "fill The Field";                          
    }      
    if(reEnterNewPasswordController.text!=newPasswordController.text){
      return "Passwords Does not Match ";
    } 
    return null;
  }
   
  Future<void> updatePasswordButton(context) async {
    if (formKey.currentState!.validate()) {
      changeUpdatePasswordIsLoading(true);
      log("Form is valid");
      
      try {      
        
        await ProfileScreenProvider().updateUserPassword(
          currentPassword: oldPasswordController.text, 
          newPassword: newPasswordController.text, 
          confirmPassword: reEnterNewPasswordController.text
        );       

        oldPasswordController.clear();
        newPasswordController.clear();
        reEnterNewPasswordController.clear();
        if (!context.mounted) return;
        customSnackbar(context,false,"Password Updated Succesfuly");
        
        changeUpdatePasswordIsLoading(false);
      } catch (e) {
        log("Update Password failed");
        changeUpdatePasswordIsLoading(false);
        if (!context.mounted) return;
        customSnackbar(context,true,AuthService.apiMessege);
        
      }

    } else {
      log("Form is NOT valid");
      if (!context.mounted) return;
      customSnackbar(context,true,"Form Is NOT Valid");
      
    }
  } 

  void resetProvider() {
    oldPasswordController.clear();
    newPasswordController.clear();
    reEnterNewPasswordController.clear();
    updatePasswordisloading = false;
    notifyListeners();
  }

}