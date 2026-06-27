import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/logic/voice_analysis_provider.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/voice_record_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class StartVoiceScanScreen extends StatelessWidget {
  const StartVoiceScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(      
      child: Scaffold(      
        appBar: AppBar(),       
        
      
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            
              children: [
                SizedBox(height: 80.h,),
                SvgPicture.asset(
                  "assets/images/mic_icon_white.svg",
                  width: 146.w,
                  height: 180.h,
                ),
                SizedBox(height: 40.h,),
                Text(
                  "Voice Scan",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: AppColers.primaryColor,
                  ),        
                ),
                SizedBox(height: 40.h,),
            
                Text(
                  "An AI-powered system that listens to your voice to detect your emotional state.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),     
                  textAlign: TextAlign.center,                 
                ),
      
                SizedBox(height: 133.h,),
                Consumer<VoiceAnalysisProvider>(
                  builder: (context,val,child) {
                    return CustomButton(
                      onPressed: ()async{
                        if (val.voicePermissionAllowed) {
                          log("ok");
                          var status = await Permission.microphone.status;
                          if (!status.isGranted) {
                            await Permission.microphone.request();
                            openAppSettings();
                          }
                          if(status.isGranted){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VoiceRecordScreen()),
                            );
                          }
                          
                        } else {
                          log("no");
                          val.voicePermissionShowDialog(context);
                        }
                          
                      },
                      text: "Start Voice Scan"
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