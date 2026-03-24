import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController loginEmailController =TextEditingController();
  TextEditingController loginpasswordController =TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isloading=false;
  bool islogined=false;

  String ? emailValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if (!val.endsWith("@gmail.com")) {
      return "Email must end with @gmail.com";
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


  void loginButton(context) {
    if (formKey.currentState!.validate()) {
      log("Form is valid");
      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text("Form is valid",style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
       )
      );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(),), (route) => false,);
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





    
