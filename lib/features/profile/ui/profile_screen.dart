import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/ui/widgets/about_user_wid.dart';
import 'package:mindsense_app/features/profile/ui/widgets/favourite_wid.dart';
import 'package:mindsense_app/features/profile/ui/widgets/general_settings_wid.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        var provider=context.read<Mainscreenprovider>();
        provider.changeIndex(0);
        log(provider.index.toString());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Profile",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
          actions: [          
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(120.r),            
              child: SvgPicture.asset(
                "assets/images/settings_icon_white.svg",
                width: 26.w,
                height: 26.h,
              ),
            ),
            SizedBox(width: 20.w,)
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal:  20.w),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children:  [
                AboutUserWid(),
                GeneralSettingsWid(),
                //FavouriteWid(),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

