import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class Exercisewid extends StatelessWidget {
  const Exercisewid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B), // Dark card background
        borderRadius: BorderRadius.circular(20.r),        
        boxShadow: [
          BoxShadow(
            color: AppColers.primaryColor.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(6,5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          
          Text(
            "Recommended Exercises",

            style: TextStyle(                    
              color: AppColers.primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,              
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Take a deep breath through your nose for 4 seconds",
                  maxLines: 2,
                  style: TextStyle(                    
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,              
                  ),
                ),
              ),
            ],
          ),          
        ],
      ),
    );
  
  }
}