import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GeneralSettingsWid extends StatelessWidget {
  const GeneralSettingsWid({super.key});

  @override
  Widget build(BuildContext context) {    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "General Settings",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),

        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Color(0xff1E293B),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
             
              SettingItemsWid(                
                title: "Security",
                iconPath: "assets/images/security.svg",
                onTap: () {
                  log("Security clicked!");
                },              
              ),
              SizedBox(height: 4.h,),

              SettingItemsWid(
                title: "Personal information",
                iconPath: "assets/images/Personalinformation_icon.svg",
                onTap: () {
                  log("Personalinformation_icon clicked!");
                },              
              ),
              SizedBox(height: 4.h,),

              SettingItemsWid(
                title: "Notification",
                iconPath: "assets/images/notification_icon.svg",
                onTap: () {
                  log("Notification clicked!");
                },              
              ),
              SizedBox(height: 4.h,),
            ],
          ),
        ),        
        
        SizedBox(height: 20.h),
      ],
    );
  }
}

class SettingItemsWid extends StatelessWidget {
  
  final String title;
  final VoidCallback onTap;
  final String iconPath; 
  
  const SettingItemsWid({
    super.key,
    required this.title,
    required this.onTap,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        splashColor: Colors.grey[600],
        onTap: onTap, 
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 4.h), 
          decoration: const BoxDecoration(),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xff55EEDA).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath, 
                    width: 22.w,
                    height: 22.w,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                title, 
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      
      ),
    );
  }
}





