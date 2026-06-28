import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
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
        customSnackbar(context,false,"Account added successfully!");
        
        verifyCodeButtonisloadingfun(false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(),),
          (route) => false,
        );       
      } catch (e) {
        log("ERROR: $e");
        verifyCodeButtonisloadingfun(false);
        customSnackbar(context,true,e.toString());
           
        signUpPinCodeController.clear();  
      }       
    }
    else {
      changeIsPinCodeError();   
      HapticFeedback.vibrate();
      customSnackbar(context,true,"Form is not valid,Enter Pin Code Again");
      log("Form is NOT valid");
      
      signUpPinCodeController.clear(); 
         
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
      customSnackbar(context,false,"Code sent again");
      
      changeIsResendCode(false);

    } catch (e) {
      customSnackbar(context,true,e.toString());
      
    } finally {
      verifyCodeButtonisloading = false;
      notifyListeners();
    }
  }
  

}