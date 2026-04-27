import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(          
          SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: const Color.fromARGB(255, 20, 116, 23),
            content: Text("Password Updated Succesfuly",style: TextStyle(
              color: Colors.white
            ),),            
          ),
        );
        changeUpdatePasswordIsLoading(false);
      } catch (e) {
        log("Update Password failed");
        changeUpdatePasswordIsLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(          
          SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
            content: Text(AuthService.apiMessege,style: TextStyle(
              color: Colors.white
            ),),            
          ),
        );
      }

    } else {
      log("Form is NOT valid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 700),
          content: Text("Form Is NOT Valid",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.red,
        ),
      );
    }
  } 
}