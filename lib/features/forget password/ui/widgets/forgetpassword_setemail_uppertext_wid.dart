import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class ForgetpasswordSetemailUppertext extends StatelessWidget {
  const ForgetpasswordSetemailUppertext({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Forgot Your Password?",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),),

        SizedBox(height: 8,),

        Text(" Let’s Get You ",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColers.primaryColor
        ),),
      ],
    );
  }
}