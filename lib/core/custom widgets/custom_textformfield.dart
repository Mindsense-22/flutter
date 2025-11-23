import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';


class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Icon;

  
  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,    
    this.validator, this.Icon,     
  }) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,      
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUnfocus,
        decoration: InputDecoration(        
          prefixIcon: Icon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: TextColers.secondaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          filled: true,
          fillColor:  AppColers.backgroundColor,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColers.primaryColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColers.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color:Colors.blueAccent,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(10),
          ),        
        ),     
        validator: validator,
      ),
    );
  }
}
