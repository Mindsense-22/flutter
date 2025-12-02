import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgetpasswordProvider extends ChangeNotifier{
  TextEditingController forgetPasswordEmailController =TextEditingController();  
  final setEmailFormKey = GlobalKey<FormState>();
  bool sendCodeButtonisloading=false;

  String ? setEmailValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if (!val.endsWith("@gmail.com")) {
      return "Email must end with @gmail.com";
    }
    
    return null;
  }

  void sendCodeButton(context) {
    if (setEmailFormKey.currentState!.validate()) {
      log("Form is valid");
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text("Form is valid",style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
       )
      );
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
    }
    else {
      log("Form is NOT valid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        content: Text("Form is not valid",style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
        )
      );
    }
  }
  
}