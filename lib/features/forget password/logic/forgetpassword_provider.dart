import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindsense_app/features/forget%20password/ui/forgetpasswoed_setnewpassword.dart';
import 'package:mindsense_app/features/forget%20password/ui/forgetpassword_setpincode.dart';


class ForgetpasswordProvider extends ChangeNotifier{
  ///////////////////////set email and send code page ////////////////////
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

  void sendCodeButton(context) async{
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
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(milliseconds: 200));
      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetpasswordSetpincode(),));
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
  ////////////////////////////////////set pin code page/////////////////////////////////////
  TextEditingController forgetPasswordPinCodeController =TextEditingController();
  final setPinCodeFormKey = GlobalKey<FormState>();
  bool ispincodeError = false;
  bool verifyCodeButtonisloading=false;
  String correctPinCode="111111";

  void verifyCodeButton(context) async{
    if (setPinCodeFormKey.currentState!.validate()&&forgetPasswordPinCodeController.text==correctPinCode) {
      resetPinError();
      log("Form is valid");
      log(forgetPasswordPinCodeController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Form is valid",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.black,
        )
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetpasswoedSetnewpassword(),));
      await Future.delayed(Duration(seconds: 2)); 
      forgetPasswordPinCodeController.clear();  // may cause error when deal with api
      
      
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
      forgetPasswordPinCodeController.clear(); // may cause error when deal with api
      await Future.delayed(Duration(seconds: 3));   
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

  /////////////////////////////////////////////////////////////////
}