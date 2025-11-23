import 'dart:developer';

import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier{

  TextEditingController signupPasswordController=TextEditingController();
  TextEditingController signupNameController=TextEditingController();
  TextEditingController signupEmailController=TextEditingController();
  final formKey = GlobalKey<FormState>();

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
    return null;
  }

  String ? passwordValidator(String ? val){
    if(val==null||val.isEmpty){
    return "fill The Field";                          
    }
    if(val.length<6){
      return "password must be more than 5 charachter";
    }
    return null;
  }


  void signupButton() {
    if (formKey.currentState!.validate()) {
      log("Form is valid");
      // Continue login logic here
    } else {
      log("Form is NOT valid");
    }
  }
}