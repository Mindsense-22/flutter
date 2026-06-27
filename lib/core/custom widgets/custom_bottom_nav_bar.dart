import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: DarkThemeColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColers.primaryColor.withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0,"assets/images/homeiconblack.svg" ,"assets/images/homeicon.svg" ,"Home"),
          _buildNavItem(1,"assets/images/mic_icon_black.svg","assets/images/mic_icon_white.svg" , "Voice"),
          _buildNavItem(2,"assets/images/doctor_icon_black.svg","assets/images/doctor_icon.svg" , "Doctors"),
          _buildNavItem(3,"assets/images/gamepadblack.svg","assets/images/gamepad.svg" , "Games"),
          _buildNavItem(4,"assets/images/community_icon_black.svg","assets/images/community_icon.svg" , "Community"),
          _buildNavItem(5,"assets/images/user-circle.svg","assets/images/user-circleblack.svg" , "Profile"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String path1,String path2 ,String label) {
    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(        
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 12.w : 6.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? DarkThemeColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              isSelected ? path1:path2,
              width: 24,
              height: 24,
            ),
            if (isSelected) ...[
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  color: DarkThemeColors.backgroundColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
