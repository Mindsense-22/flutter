import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class AboutUserWid extends StatelessWidget {
  const AboutUserWid({super.key});

  @override
  Widget build(BuildContext context) {    
    return Column(
      children: [
        SizedBox(height: 18.h),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                color: Color(0xff2DD4BF).withValues(alpha: .06),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColers.primaryColor.withValues(alpha: .5),
                  width: 1.2.w,
                ),
                
              ),
            ),
            Positioned(
              bottom: 4.w,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColers.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset("assets/images/camera_icon_black.svg",
                  height: 16.h,
                  width: 16.w,
                )
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "Ammar Elmihy",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "ammar125@gmail.com",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: .7),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

