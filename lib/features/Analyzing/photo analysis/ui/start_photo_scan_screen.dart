import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/logic/photo_analysis_provider.dart';
import 'package:mindsense_app/features/home/ui/homescreen.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:provider/provider.dart';

class StartPhotoScanScreen extends StatelessWidget {
  const StartPhotoScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,      
      onPopInvokedWithResult: (didPop, result) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(),),  (route) => false,);
      },
      child: Scaffold(
      
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,size: 24.w,),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(),),  (route) => false,);
            },
          ),
        ),
      
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            
              children: [
                SizedBox(height: 80.h,),
                SvgPicture.asset(
                  "assets/images/face_scan_icon.svg",
                  width: 200.w,
                  height: 200.h,
                ),
                SizedBox(height: 40.h,),
                Text(
                  "Photo Scan",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: AppColers.primaryColor,
                  ),        
                ),
                SizedBox(height: 40.h,),
            
                Text(
                  "An AI-powered system that\nanalyzes your facial expressions to\nunderstand your emotional state.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),     
                  textAlign: TextAlign.center,                 
                ),
      
                SizedBox(height: 133.h,),
                Consumer<PhotoAnalysisProvider>(
                  builder: (context,val,child) {
                    return CustomButton(
                      onPressed: (){
                        val.cameraPermissionAllowed?
                          log("ok"):// move to next screen 
                          log("no"); val.cameraPermissionShowDialog(context);// pop up permission widget
                      },
                      text: "Start Photo Scan"
                    );
                  }
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}