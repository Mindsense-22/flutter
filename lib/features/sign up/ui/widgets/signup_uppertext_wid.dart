import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class SignupUppertextWid extends StatelessWidget {
  const SignupUppertextWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to",style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSecondary,
            ),),
            Text("MindSense",style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: TextColers.thirdTextColor,
              
            ),),
          ],
        ),
      ],
    );
  }
}