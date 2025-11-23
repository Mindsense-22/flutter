import 'package:flutter/material.dart';

class SignupPlatformsAuthWid extends StatelessWidget {
  const SignupPlatformsAuthWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 50,
      children: [
        InkWell(
          onTap: () {
            
          },
          child: Image.asset("assets/images/google.png"),
        ),
            
        InkWell(
          onTap: () {
            
          },
          child: Image.asset("assets/images/apple.png"),
        ),
            
        InkWell(
          onTap: () {
            
          },
          child: Image.asset("assets/images/facebook.png"),
        ),
        
      ],
    );                             
  }
}