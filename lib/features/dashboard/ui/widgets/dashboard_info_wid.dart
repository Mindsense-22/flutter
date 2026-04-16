import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DashboardInfoWid extends StatelessWidget {
  const DashboardInfoWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35.h,
      decoration: BoxDecoration(

      ),
      child:
       Row(
         //spacing: 53.w,
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          //// for face info
          SizedBox(
            width: 54.w,
            child: Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Color(0xff99F6E4),
                    shape: BoxShape.circle
                  ),
                ),
                SizedBox(width: 4.w,),
                Text(
                  "Face",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff8D9092),
                  ),
                ),
              ],
            ),
          ),

          //// for audio info
          SizedBox(
            width: 66.w,
            child: Row(
              children: [
                Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Color(0xff2DD4BF),
                    shape: BoxShape.circle
                  ),
                ),
                SizedBox(width: 4.w,),
                Text(
                  "Audio",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff8D9092),
                  ),
                ),
              ],
            ),
          ),
          //// time indication
          InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: () {
              
            },
            child: Container(
              height: 35.h,
              width: 110.w,                  
              padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 7.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.onSecondary,
                  width: 1.w, 
                ),
                borderRadius: BorderRadius.circular(10.r)
              ),
              child: Stack(
                children: [
                  Text(
                    "This week ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffFCFDFF),
                    ),
                  ),
                  Positioned(
                    top: 7.8.h,
                    right: 1.5.w,
                    child: SvgPicture.asset(
                      "assets/images/Arrow---Down-2.svg",
                      width: 13.w,
                      height: 7.h,
                    ),                  
                  ),
                ],
                
              ),
            ),
          ),          
        ],
      ),

     
    );
  }
}