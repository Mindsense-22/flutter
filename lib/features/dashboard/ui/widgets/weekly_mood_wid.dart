import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:provider/provider.dart';

class WeeklyMoodWid extends StatelessWidget {
  const WeeklyMoodWid({super.key});

  @override
  Widget build(BuildContext context) {
    var provider=context.read<DashboardProvider>();
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
                width: 40.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: AppColers.primaryColor.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/dashbord_icon2.svg",
                    width: 28.w,
                    height: 28.h,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "Weekly Mood Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              
            ],
          ),
          SizedBox(height: 15.h),
          
          RichText(   
            maxLines: 3,         
            text: TextSpan(              
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.5.sp,
                fontWeight: FontWeight.w500, 
                height: 1.4.h  ,
                           
              ),
              children: [
                TextSpan(text: "This week’s analysis of your face and\nvoice suggests "),

                TextSpan(
                  text: provider.userStatus,
                  style: TextStyle(
                    color: AppColers.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,                    
                  ),
                ),

                TextSpan(text: " balanced by periods of calm and control."),
              ]
            )
          ),
        ],
      ),
    );
      
  }
}