import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
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
  changeSendCodeButtonIsLoading(bool val){
    sendCodeButtonisloading=val;
    notifyListeners();
  }
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
        changeSendCodeButtonIsLoading(true);
        
        
        await AuthService.forgotPassword(forgetPasswordEmailController.text);
        
        changeSendCodeButtonIsLoading(false);
        if (!context.mounted) return;
        customSnackbar(context,false,"Code sent to your email");
        
        SharedPreferencesitem.setString("forgetPasswordEmailController", forgetPasswordEmailController.text);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetpasswordSetpincode()));
      } catch (e) {
        changeSendCodeButtonIsLoading(false);
        notifyListeners();
        log(e.toString());
        if (!context.mounted) return;
        customSnackbar(context,true,AuthService.apiMessege.toString());
        
      }
    }
    else {
      log("Form is NOT valid");
      if (!context.mounted) return;
      customSnackbar(context,true,"Form is not valid");
      
    }
  }
  ////////////////////////////////////set pin code page/////////////////////////////////////
  TextEditingController forgetPasswordPinCodeController =TextEditingController();
  final setPinCodeFormKey = GlobalKey<FormState>();
  bool ispincodeError = false;
  bool verifyCodeButtonisloading=false;
  
  changeVerifyCodeButtonIsLoading(bool val ){
    verifyCodeButtonisloading=val;
    notifyListeners();
  }
  void verifyCodeButton(context) async{
    if (setPinCodeFormKey.currentState!.validate()) {
      resetPinError();
      log("Form is valid");
      
      try {
        changeVerifyCodeButtonIsLoading(true);
        String testemail=SharedPreferencesitem.getString("forgetPasswordEmailController")!;
        await AuthService.verifyResetCode(
          testemail,
          forgetPasswordPinCodeController.text
        );
        
        print(forgetPasswordEmailController.text.isEmpty.toString());
        changeVerifyCodeButtonIsLoading(false);
        await SharedPreferencesitem.setString("forgetPasswordPinCodeController", forgetPasswordPinCodeController.text);
        if (!context.mounted) return;
        customSnackbar(context,false,"Code verified successfully");
        
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetpasswoedSetnewpassword()));
      } catch (e) {
        changeVerifyCodeButtonIsLoading(false);
        HapticFeedback.vibrate();
        log(forgetPasswordEmailController.text.toString());
        log(e.toString());
        if (!context.mounted) return;
        customSnackbar(context,true,e.toString());
        
        
        await Future.delayed(Duration(seconds: 3));   
        resetPinError();
      }
    }
    else {
      changeIsPinCodeError();   
      HapticFeedback.vibrate();

      log("Form is NOT valid");
      if (!context.mounted) return;
      customSnackbar(context,true,"Eror,Enter Pin Code Again");
         
      
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
  ///// for resend pin code
  bool resedcodebuttonloading=false;

  void resendCode()async{
    resedcodebuttonloading=true;
    notifyListeners();
    
    
    String testeamil=SharedPreferencesitem.getString("forgetPasswordEmailController")!;
    
    await AuthService.forgotPassword(testeamil);
    resedcodebuttonloading=false;
    notifyListeners();
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
        String testemail=SharedPreferencesitem.getString("forgetPasswordEmailController")!;
        String testpincode=SharedPreferencesitem.getString("forgetPasswordPinCodeController")!;
        final response=await AuthService.resetPassword(
          testemail,
          testpincode, 
          setNewPasswoedController.text
        );
        var token=response;
        resetPasswordButtonisloading = false;
        passwordChangeSuccessfuly = true;
        notifyListeners();
        if (!context.mounted) return;
        customSnackbar(context,false,"Password reset successful");
        
        messgeShowDialog(context);
        SharedPreferencesitem.clear();
      } catch (e) {
        resetPasswordButtonisloading = false;
        notifyListeners();
        log(e.toString());
        if (!context.mounted) return;
        customSnackbar(context,true,e.toString());
        
      }
    }
    else {
      log("Form is NOT valid");
      if (!context.mounted) return;
      customSnackbar(context,true,"Form is not valid");
      
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
                    color: Color(0xff06152D),
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
                            color: Theme.of(context).colorScheme.onSecondary,
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

  void resetProvider() {
    forgetPasswordEmailController.clear();
    sendCodeButtonisloading = false;
    forgetPasswordPinCodeController.clear();
    ispincodeError = false;
    verifyCodeButtonisloading = false;
    resedcodebuttonloading = false;
    setNewPasswoedController.clear();
    confirmPasswoedController.clear();
    resetPasswordButtonisloading = false;
    passwordChangeSuccessfuly = false;
    notifyListeners();
  }

}