import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/logic/voice_analysis_provider.dart';
import 'package:provider/provider.dart';

class VoiceRecordScreen extends StatelessWidget {
  const VoiceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),

      body: Padding(
        padding:EdgeInsets.symmetric(horizontal:20.0.w),
        child: Consumer<VoiceAnalysisProvider>(
          builder: (context,val,child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.h,),
                Text(
                  "Try saying",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColers.primaryColor,
                  ),
                ),
                Text(                  
                  "Today I feel calm but a little tired",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(                  
                      "Or",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    Text(                  
                      " say anything",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColers.primaryColor,
                      ),
                    ),
                    Text(                  
                      " you prefer",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h,),
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: AppColers.primaryColor,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/mic-black-2.svg",
                      width: 60.w,
                      height: 60.h,
                    ),
                  ),
                ),
                SizedBox(height: 24.h,),
                //timer
                SizedBox(height: 40.h,width: 92.w,
                  child: Center(
                    child: Text(
                      val.formatTime(val.recordTime),
                      style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),),
                  ),
                ),

                SizedBox(height: 24.h,),
                SizedBox(height: 60.h,width: 166.w,),
                SizedBox(height: 102.h,),
                ///// control buttons
                SizedBox(
                  height: 200.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        spacing: 145.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [                          
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            splashColor: Colors.white.withValues(alpha: 0.2),
                            highlightColor: Colors.transparent,
                            onTap: () {
                              val.cancelRecording();
                            },
                            child: Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                
                              ),
                              child: SvgPicture.asset(
                                "assets/images/cancel-audio-button.svg",
                              ),
                            ),
                          ),                          
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            splashColor: Colors.white.withValues(alpha: 0.2),
                            highlightColor: Colors.transparent,
                            onTap: () {

                            },
                            child: Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                
                              ),
                              child: SvgPicture.asset(
                                "assets/images/replay-audio-button.svg",
                              ),
                            ),
                          ),

                          
                        ],
                      ),
                      //centered button
                      Positioned(
                        top: 32.h,
                        child:
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          splashColor: Colors.white.withValues(alpha: 0.2),
                          highlightColor: Colors.transparent,
                          onTap: () {
                            val.changeIsRecording();
                          },
                          child: Container(
                            width: 66.w,
                            height: 66.h,
                            decoration: BoxDecoration(
                              
                            ),
                            child: SvgPicture.asset(
                              val.isRecording?"assets/images/pause-audio-button.svg":"assets/images/resume-audio-button.svg"
                            ),
                          ),
                        ),                        
                      ),

                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}