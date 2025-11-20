import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class CustomButton extends StatelessWidget {
   CustomButton({super.key, this.onpreessed, required this.text});
  final String? Function(String?)? onpreessed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColers.primaryColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: MaterialButton(
        onPressed:(){onpreessed;},
        child: Text(text,style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),),                    
      ),
    ) ;
  }
}