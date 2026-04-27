import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/home/ui/homescreen.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';

import 'package:mindsense_app/features/sign%20up/ui/signup_setpincode_screen.dart';

class SignupProvider extends ChangeNotifier{

  TextEditingController signupPasswordController=TextEditingController();
  TextEditingController signupReEnterPasswordController=TextEditingController();
  TextEditingController signupNameController=TextEditingController();
  TextEditingController signupEmailController=TextEditingController();
  TextEditingController signupAgeController=TextEditingController();
  final formKey = GlobalKey<FormState>();
 
  bool signupbuttonisloading=false;
  
  
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
        );

        await SharedPreferencesitem.setString(
          "userEmail",
          signupEmailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Pin Code sent To your Email"),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupSetpincodeScreen(
              context: context,
            ),
          ),
        );
        changeSignupButtonIsLoading(false);
      } catch (e) {
        log("Signup failed");
        changeSignupButtonIsLoading(false);
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