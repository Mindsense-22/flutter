import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/sign%20up/logic/signup_provider.dart';
import 'package:pinput/pinput.dart';

class SignupPincodetextfieldWid extends StatelessWidget {
  const SignupPincodetextfieldWid({super.key, required this.provider});
  final SignupProvider provider;
  @override
  Widget build(BuildContext context) {

    final errorPinTheme = PinTheme(
      width: 55.w,
      height: 50.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.red,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.red, width: 2.5),
        //color: Colors.red.withOpacity(0.1),
        color: Colors.grey[400],
      ),
    );

    return Pinput( 
      cursor: Container(
        width: 2,
        height: 24,
        color: Theme.of(context).colorScheme.onSecondary,
      ),           
      controller: provider.signUpPinCodeController,
      length: 6,
      
      keyboardType: TextInputType.number,
      autofocus: false,
      showCursor: true,     
      

      defaultPinTheme: provider.ispincodeError
          ? errorPinTheme
          : PinTheme(
              width: 55.w,
              height: 50.h,
              textStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.blue, width: 1.4),
                color: Colors.grey[400],
              ),
            ),

      focusedPinTheme: provider.ispincodeError
          ? errorPinTheme
          : PinTheme(              
              width: 55.w,
              height: 50.h,
              textStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.blue, width: 2),
                color: Colors.transparent,
                
              ),

            ),

      submittedPinTheme: provider.ispincodeError
          ? errorPinTheme
          : PinTheme(
              width: 55.w,
              height: 50.h,
              textStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColers.primaryColor, width: 2),
                color: Colors.grey.shade100,
              ),
            ),

      errorPinTheme: errorPinTheme,
      
    );
  }


}