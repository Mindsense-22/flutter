import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/logic/voice_analysis_provider.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/voice_scan_result_screen.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/widgets/voicewave_wid.dart';
import 'package:provider/provider.dart';

class VoiceRecordScreen extends StatelessWidget {
  const VoiceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,      
      child: Scaffold(
        
        appBar: AppBar(
      
        ),
      
        body: Padding(
          padding:EdgeInsets.symmetric(horizontal:20.0.w),
          child: Consumer<VoiceAnalysisProvider>(
            builder: (context,val,child) {
              return SingleChildScrollView(
                child: Column(
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
                    SizedBox(height: 40.h,
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
                    
                    //// wave form paint
                    val.isRecording==true? 
                    Selector<VoiceAnalysisProvider, List<double>>(
                      selector: (_, provider) => provider.amplitudes,
                      builder: (_, amplitudes, __) {
                        return VoiceWave(amplitudes: amplitudes);
                      },
                    )
                    :SizedBox(width: 200.w,height: 65.h,),

                    SizedBox(height: 60.h,),
                    ///// control buttons
                    SizedBox(
                      height: 180.h,
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
                                  //old functions
                                  // val.audioFile=null;
                                  // val.cancelRecording();
                                  // val.changeIsRecording();
                                  val.stopRecording();
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
                                        
                    val.isRecording == false && val.audioFile != null&&val.recoredStoped==true&&val.recordTime!=0
                    ? Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VoiceScanResultScreen()),
                            );                              
                          }, 
                          text: "Finish"
                        ),
                        TextButton(
                            onPressed: () {
                              val.playRecordedAudio();
                            },
                            child: const Text("Play audio",),
                        ),                                                  
                      ],
                    )
                    : const SizedBox.shrink()
                    
      
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}