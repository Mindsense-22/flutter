import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class UppertextWid extends StatelessWidget {
  const UppertextWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome",style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),),
            Text("back!",style:TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: TextColers.thirdTextColor,
              
            ),),
          ],
        ),

        SizedBox(height: 8,),

        Text("Login to your account",style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSecondary,
        ),),
      ],
    );
  }
}