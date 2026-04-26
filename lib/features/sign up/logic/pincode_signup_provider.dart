import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';


class PincodeSignupProvider extends ChangeNotifier{
  
  
  TextEditingController signUpPinCodeController =TextEditingController();
  final setPinCodeFormKey = GlobalKey<FormState>();
  bool ispincodeError = false;
  bool verifyCodeButtonisloading=false;

  void verifyCodeButtonisloadingfun(val){
    verifyCodeButtonisloading=val;
    notifyListeners();
  }

  void checkSignUpPinCode(context) async{
    if (setPinCodeFormKey.currentState!.validate()) {
      resetPinError();
      log("Form is valid");
      verifyCodeButtonisloadingfun(true);
      try {
        final result = await AuthService.verifyPinCode(
          email: SharedPreferencesitem.getString("gmail")??"Test@gmail.com",
          code: signUpPinCodeController.text,
        );
        log("TOKEN: ${result.token}");
        log("USER: ${result.user.name}");
        await SharedPreferencesitem.setString("username", result.user.name);
        await SharedPreferencesitem.setString("token", result.token);
        await SharedPreferencesitem.setInt("userage", result.user.age);
        await SharedPreferencesitem.setString("userid", result.user.id);
        await SharedPreferencesitem.setBool("isverified", result.user.isVerified); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1500),
            content: Text(
              "Account added successfully!",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 34, 75, 36),
          ),
        );
        verifyCodeButtonisloadingfun(false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(),),
          (route) => false,
        );       
      } catch (e) {
        log("ERROR: $e");
        verifyCodeButtonisloadingfun(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds:1500 ),
            content: Text(e.toString(),style: TextStyle(
              color: Colors.white
            ),),
            backgroundColor: Colors.red,
          )
        );   
        signUpPinCodeController.clear();  
      }       
    }
    else {
      changeIsPinCodeError();   
      HapticFeedback.vibrate();

      log("Form is NOT valid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds:1500 ),
          content: Text("Form is not valid , Enter Pin Code Again",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.black,
        ),
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
  
  // resend code

  bool isresendcode=false;
  changeIsResendCode(val){
    isresendcode=val;
    notifyListeners();
  }
  Future<void> resendCode(context) async {
    changeIsResendCode(true);
    try {  
      final email = SharedPreferencesitem.getString("gmail");

      await AuthService.resendSignUpPinCode(email!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Code sent again"),
          backgroundColor: Colors.green,
        ),
      );
      changeIsResendCode(false);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      verifyCodeButtonisloading = false;
      notifyListeners();
    }
  }
  

}