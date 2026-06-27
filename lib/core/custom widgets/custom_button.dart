import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class CustomButton extends StatelessWidget {
   final VoidCallback onPressed; 
   final String text;
   CustomButton({super.key,  required this.onPressed, required this.text});
   
  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: double.infinity,       
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColers.primaryColor,
        borderRadius: BorderRadius.circular(10)
      ),
      child: MaterialButton(
       
        
        padding: EdgeInsets.all(8),
        onPressed:onPressed,
        child: Text(text,style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),),                    
      ),
    ) ;
  }
}