import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XAxis extends StatelessWidget {
  
  const XAxis({super.key,});

  @override
  Widget build(BuildContext context) {
    final days =
        const [
          'Sat',
          'Sun',
          'Mon',
          'Thurs',
          'Wed',
          'Tues',
          'Fri',
        ];
    return Row(   
      mainAxisAlignment: MainAxisAlignment.start,           
      children: [
        SizedBox(width: 29.w,),
        Row(
          children: [
            SizedBox(
              height: 17.h,
              width: 23.w,
              child: Text(
                days[0],
                style: TextStyle(
                  color: const Color(0xFFcecece),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(width: 18.33.w,),

            SizedBox(
              height: 17.h,
              width: 28.w,
              child: Text(
                days[1],
                style: TextStyle(
                  color: const Color(0xFFcecece),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(width: 18.33.w,),

            SizedBox(
              height: 21.h,
              width: 30.w,
              child: Text(
                days[2],
                style: TextStyle(
                  color: const Color(0xFFcecece),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(width: 18.33.w,),

            SizedBox(
              height: 17.h,
              width: 33.w,
              child: Text(
                days[3],
                style: TextStyle(
                  color: const Color(0xFFcecece),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(width: 18.33.w,),

            SizedBox(
              height: 17.h,
              width: 32.w,
              child: Text(
                days[4],
                style: TextStyle(
                  color: const Color(0xFFcecece),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(width: 18.33.w,),

            SizedBox(
              height: 17.h,
              width: 39.w,
              child: Text(
                days[5],
                style: TextStyle(
                  color: const Color(0xFFcecece),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            SizedBox(width: 18.33.w,),

            SizedBox(
              height: 17.h,
              width: 17.w,
              child: Text(
                days[6],
                style: TextStyle(
                  color: const Color(0xFFcecece),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                  
                ),
              ),
            ),
            
        
        
        
          ],
        ),
        
      ],
      
    );
    
  }



}






