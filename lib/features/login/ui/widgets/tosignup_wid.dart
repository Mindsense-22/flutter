import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/sign%20up/ui/signup_screen.dart';

class TosignupWid extends StatelessWidget {
  const TosignupWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      
      children: [
        Text("Don't have an account?",style: TextStyle(
          fontSize: 20.spMin,
          fontWeight: FontWeight.w500,
        ),),
        TextButton(                    
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) =>
             SignupScreen(),)
            );
          },
          child: Text("Sign Up",                                
            style: TextStyle(
              fontSize: 20.spMin,
          fontWeight: FontWeight.w500,
              color: TextColers.thirdTextColor
        ),)),
      ],
    );
  }
}