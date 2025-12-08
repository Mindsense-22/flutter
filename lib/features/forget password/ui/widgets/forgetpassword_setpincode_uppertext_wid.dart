import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class ForgetpasswordSetpincodeUppertextWid extends StatelessWidget {
  const ForgetpasswordSetpincodeUppertextWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("We’ve sent a verification ",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),),

        Text("code to your email",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),),

        SizedBox(height: 8,),

        Text(" Enter it here ",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColers.primaryColor
        ),),
      ],
    );
  }
}