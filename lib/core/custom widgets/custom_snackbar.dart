import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

void customSnackbar(context,final bool isRed,final String content,){  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor:isRed?const Color.fromARGB(255, 222, 75, 64):Color.fromARGB(255, 42, 58, 84),
      duration: Duration(milliseconds: 1400),
      behavior: SnackBarBehavior.floating,
      width: MediaQuery.of(context).size.width * 0.85,
      
      content: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,        
          spacing: 13.w,
          children: [
            SvgPicture.asset(
              'assets/images/logologo.svg',
              width: 20.w,
              height: 20.h,
              
            ),
            
            Expanded(
              child: Text(content,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white
              ),),
            )
          ],
        ),
      ),
    ),
  );  
}  