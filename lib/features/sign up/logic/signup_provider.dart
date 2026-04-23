import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/home/ui/homescreen.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:mindsense_app/features/sign%20up/ui/signup_setpincode_screen.dart';

class SignupProvider extends ChangeNotifier{

  TextEditingController signupPasswordController=TextEditingController();
  TextEditingController signupReEnterPasswordController=TextEditingController();
  TextEditingController signupNameController=TextEditingController();
  TextEditingController signupEmailController=TextEditingController();
  final formKey = GlobalKey<FormState>();
  TextEditingController signUpPinCodeController =TextEditingController();
  final setPinCodeFormKey = GlobalKey<FormState>();
  bool ispincodeError = false;
  bool verifyCodeButtonisloading=false;
  String correctPinCode="111111";

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

  String ? passwordValidator(String ? val){
    if(val==null||val.isEmpty){
    return "fill The Field";                          
    }
    if(val.length<6){
      return "password must be more than 5 charachter";
    }
    if (!RegExp(r'[a-z]').hasMatch(val)||!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(val)||!RegExp(r'[A-Z]').hasMatch(val)) {
      return "Password must contain  lowercase letter,uppercase letter,\nspecial character";
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
  /////pin code
  //get orignal token from api
  Future<void> getUserToken()async{

  }
  void checkSignUpPinCode(context) async{
    if (setPinCodeFormKey.currentState!.validate()&&signUpPinCodeController.text==correctPinCode) {
      resetPinError();
      log("Form is valid");
      log(signUpPinCodeController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Form is valid",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.black,
        )
      );
      await SharedPreferencesitem.setString("token", signUpPinCodeController.text);
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(),),
        (route) => false,
      );      
      
      signUpPinCodeController.clear();  // may cause error when deal with api
      
      
    }
    else {
      changeIsPinCodeError();   
      HapticFeedback.vibrate();

      log("Form is NOT valid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds:3000 ),
          content: Text("Form is not valid , Enter Pin Code Again",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.black,
        )
      );
      signUpPinCodeController.clear(); // may cause error when deal with api
         
      resetPinError();
    }
  }
  void changeIsPinCodeError(){
    ispincodeError = true;
    notifyListeners();
  }

  void resetPinError(){
    ispincodeError=false;
    notifyListeners();
  }
  void resendCode(){

  }
  /////////////////////////////////////////////////
  ///uplaod user data and get token
  Future<void> signupButton(context) async{
    if (formKey.currentState!.validate()) {
      log("Form is valid");
      await SharedPreferencesitem.setString("gmail", signupEmailController.text);
      // Continue signup logic here

      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupSetpincodeScreen(context: context,),));
    } else {
      log("Form is NOT valid");
    }
  }
}