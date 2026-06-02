import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/profile/add%20contact/ui/addcontact_screen.dart';
import 'package:mindsense_app/features/profile/delete%20account/ui/deleteaccount_screen.dart';
import 'package:mindsense_app/features/profile/edit%20user%20information/ui/editinformation_screen.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/profile/update%20password/ui/updatepassword_screen.dart';
import 'package:provider/provider.dart';

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
             
              // SettingItemsWid(   
              //   context: context,             
              //   title: "Security",
              //   iconPath: "assets/images/security.svg",
              //   onTap: () {
              //     log("Security clicked!");
              //   },              
              // ),
              // SizedBox(height: 4.h,),

              SettingItemsWid(
                context: context,
                title: "Edit Personal information",
                iconPath: "assets/images/Personalinformation_icon.svg",
                onTap: () async{
                  log("Personalinformation_icon clicked!");
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditinformationScreen()),
                  );

                  if (result == true) {
                    await context.read<ProfileScreenProvider>().init();
                  }
                },              
              ),
              SizedBox(height: 4.h,),

              SettingItemsWid(
                context: context,
                title: "Add Trusted Contact",
                iconPath: "assets/images/contact_test.svg",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddcontactScreen(),)
                  );
                },              
              ),
              SizedBox(height: 4.h,),

              SettingItemsWid(
                context: context,
                title: "Update Password",
                iconPath: "assets/images/lock-password.svg",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdatepasswordScreen(),)
                  );
                },              
              ),
              SizedBox(height: 4.h,),

              // SettingItemsWid(
              //   context: context,
              //   title: "Notification",
              //   iconPath: "assets/images/notification_icon.svg",
              //   onTap: () {
              //     log("Notification clicked!");
              //   },              
              // ),

              SizedBox(height: 4.h,),
              // SettingItemsWid(
              //   context: context,
              //   title: "Delete Account",
              //   iconPath: "assets/images/Personalinformation_icon.svg",
              //   onTap: () {
              //     log("Delete Account clicked!");
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => DeleteaccountScreen(),)
              //     );
              //   },              
              // ),
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
  final context; 
  
  const SettingItemsWid({
    super.key,
    required this.title,
    required this.onTap,
    required this.iconPath,required this.context,
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
                    color:title=="Delete Account"?Colors.red: AppColers.primaryColor,
                    
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                title, 
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: title=="Delete Account"?Colors.red: Colors.white,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: title=="Delete Account"?Colors.red:  Colors.white,),
            ],
          ),
        ),
      
      ),
    );
  }
}





