import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class ForgetpasswoedSetnewpasswordUppertextWid extends StatelessWidget {
  const ForgetpasswoedSetnewpasswordUppertextWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter a ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            Text(
              "new password ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: AppColers.primaryColor,
              ),
            ),
            Text(
              "to",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
        Text(
          "secure your account",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        )
      ],
    );
  }
}