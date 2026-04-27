import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/forget%20password/ui/forgetpasswoed_setnewpassword.dart';
import 'package:mindsense_app/features/forget%20password/ui/forgetpassword_setpincode.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/core/Api/authservice.dart';


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
      FocusScope.of(context).unfocus();
      
      try {
        sendCodeButtonisloading = true;
        notifyListeners();
        
        await AuthService.forgotPassword(forgetPasswordEmailController.text);
        
        sendCodeButtonisloading = false;
        notifyListeners();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Code sent to your email", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          )
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetpasswordSetpincode()));
      } catch (e) {
        sendCodeButtonisloading = false;
        notifyListeners();
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString(), style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          )
        );
      }
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
    if (setPinCodeFormKey.currentState!.validate()) {
      resetPinError();
      log("Form is valid");
      
      try {
        verifyCodeButtonisloading = true;
        notifyListeners();
        
        await AuthService.verifyResetCode(
          forgetPasswordEmailController.text,
          forgetPasswordPinCodeController.text
        );
        
        verifyCodeButtonisloading = false;
        notifyListeners();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Code verified successfully", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          )
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetpasswoedSetnewpassword()));
      } catch (e) {
        verifyCodeButtonisloading = false;
        changeIsPinCodeError();
        HapticFeedback.vibrate();
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 3000),
            content: Text(e.toString(), style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          )
        );
        forgetPasswordPinCodeController.clear();
        await Future.delayed(Duration(seconds: 3));   
        resetPinError();
      }
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
      forgetPasswordPinCodeController.clear();
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


  ////////////////////////////////New Password page/////////////////////////////////
  
  TextEditingController setNewPasswoedController=TextEditingController();
  TextEditingController confirmPasswoedController=TextEditingController();
  final setNewPasswoedFormKey = GlobalKey<FormState>();
  bool resetPasswordButtonisloading=false;
  bool passwordChangeSuccessfuly=false;
  String ? passwordValidator(String ? val){
    if(val==null||val.isEmpty){
    return "fill The Field";                          
    }
    if(val.length<6){
      return "password must be more than 5 charachter";
    }
    return null;
  }

  String ? confirmPasswordValidator(String ? val){
    if(val==null||val.isEmpty){
    return "fill The Field";                          
    }
    
    if(confirmPasswoedController.text!=setNewPasswoedController.text){
      return "Password Does not match";
    }
    return null;
  }

   void resetPasswordButton(context) async {
    if (setNewPasswoedFormKey.currentState!.validate()) {
      log("Form is valid");
      
      try {
        resetPasswordButtonisloading = true;
        notifyListeners();
        
        await AuthService.resetPassword(
          forgetPasswordEmailController.text,
          forgetPasswordPinCodeController.text, // note: needs code, we kept it in memory... wait! We cleared it in verifyCodeButton! 
          setNewPasswoedController.text
        );
        
        resetPasswordButtonisloading = false;
        passwordChangeSuccessfuly = true;
        notifyListeners();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password reset successful", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          )
        );
      } catch (e) {
        resetPasswordButtonisloading = false;
        notifyListeners();
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString(), style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          )
        );
      }
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
  
  Future<dynamic> messgeShowDialog(context){
    return showDialog(
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                 //color: Colors.black.withOpacity(0.3),
                   color: AppColers.backgroundColor.withValues(alpha: .3),
                ),
              ),
          
              // Popup Card
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 335.w,
                  height: 309.h,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    //color: Colors.white.withValues(alpha: .7),
                    color: Color(0xff06152D),
                    //color: AppColers.backgroundColor.withValues(alpha: .6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13,right: 13),
                    child: Column(  
                      crossAxisAlignment: CrossAxisAlignment.center,                  
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: AppColers.primaryColor,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/message-notif.svg",
                              width: 42.w,
                              height: 42.h,
                            ),                          
                          ),
                    
                        ),
                        SizedBox(height: 16.h,),
                        Text(
                          "Success!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.onSecondary,
                            //color: Colors.white
                          ),
                        ),
                        SizedBox(height: 16.h,),
                        Text(                      
                          "Your password has been reset\nsuccessfully",
                          textAlign: TextAlign.center ,
                          style: TextStyle(                      
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            //color: Color(0xff59615E)
                            color: Theme.of(context).colorScheme.onSecondary,
                            //color: Colors.white
                          ),
                        ), 
                        SizedBox(height: 16.h,),                
                        CustomButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(builder: (context) => LoginScreen(),), 
                              (route) => false,
                            );
                            //Navigator.pop(context);
                          },
                          text: "Back to Login"
                        )
                      ],
                    ),
                  ),
                ),
              ),
            
            ],
          ),
        );
      }
    );
  }


}