import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/styles/colors.dart';

class Tipwid extends StatelessWidget {
  const Tipwid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B), 
        borderRadius: BorderRadius.circular(20.r),        
        boxShadow: [          
          BoxShadow(            
            color: Color(0xff3DCADC).withAlpha(50),
            blurRadius: 4.r,
            offset: const Offset(2,2),
          ),
          BoxShadow(            
            color: Color(0xff55EEDA).withAlpha(50),
            blurRadius: 4.r,
            offset: const Offset(1.5,4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColers.primaryColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/tipsicon.svg",
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "tip",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                width: 30.w,
                height: 18.h,
                decoration: BoxDecoration(                
                  color: AppColers.primaryColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  "New",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "Try to take a small break, breathe deeply, or talk to someone you trust",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,              
            ),
          ),
        ],
      ),
    );
  
  }
}