import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';

class TologinWidget extends StatelessWidget {
  const TologinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(" Don you have an account?",style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),),
        TextButton(                    
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Log In",                      
            style: TextStyle(
              fontSize: 20,
          fontWeight: FontWeight.w500,
              color: TextColers.thirdTextColor
        ),)),
      ],
    );
                    
  }
}