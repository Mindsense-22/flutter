import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';

class FavouriteWid extends StatelessWidget {
  const FavouriteWid({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Favourite",
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
              //cell 1
              InkWell(
                onTap: (){
                  log("Language");
                },

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
                            "assets/images/language_icon.svg",
                            width: 22.w,
                            height: 22.w,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Language", 
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "English",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp
                      ),),
                      SizedBox(width: 8.w,),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 9.h,),
              //cell 2
              Container(
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
                          "assets/images/darkmode_icon.svg",
                          width: 22.w,
                          height: 22.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      "Dark Mode", 
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                    const Spacer(),
                    Consumer<ProfileScreenProvider>(
                      builder: (context,provider,cild) {
                        return Switch(
                          value: provider.isDarkMode,
                        activeThumbColor : AppColers.primaryColor,
                        onChanged: (value) {
                          provider.toggleDarkMode(value);
                          log(provider.isDarkMode.toString());
                        },
                        );
                      },
                    ),
                    
                  ],
                ),
              ),
            
            
            ],
          ),
        
        ),
      ],
    );
  }
}