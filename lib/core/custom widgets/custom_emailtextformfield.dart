import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';


class CustomEmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final Icon;

  
  const CustomEmailTextFormField({
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
          // prefixIcon: Icon,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(11.0),
            child: SvgPicture.asset(
              "assets/images/email_icon.svg",
              width: 21.5.w,
              height: 18.5.h,
            ),
          ),
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
