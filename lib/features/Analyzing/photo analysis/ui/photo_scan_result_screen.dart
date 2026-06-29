

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/logic/photo_analysis_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/start_photo_scan_screen.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/report_screen.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/start_voice_scan_screen.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:provider/provider.dart';

class PhotoScanResultScreen extends StatelessWidget {
  const PhotoScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    
      ),
      
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Consumer<AnalyzingProvider>(
          builder: (context,analyzingProvider,child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            
                SizedBox(height: 60.5.h,),
            
                Container(
                  height: 119.h,
                  width: 119.w,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(119.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: .25),
                        blurRadius: 15,
                        offset: const Offset(0,16),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/images/correct_icon.svg",
                      width: 20.w,
                      height: 46.h,
                      
                    ),
                  ),
                ),
            
                SizedBox(height: 48.h,),
            
                Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700
                  ),
                ),
            
                SizedBox(height: 24.h,),
            
                Text(
                  "Your image has been successfully analyzed! Now, continue to\nanalyze your voice",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.center,
                ),
            
                SizedBox(height: 48.h,),
                analyzingProvider.analysistype=="all"?
                Container(      
                  width: double.infinity,
                  height: 51.h,       
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColers.primaryColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: MaterialButton( 
                    padding: EdgeInsets.all(8),
                    onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StartVoiceScanScreen(),));
                      WidgetsBinding.instance.addPostFrameCallback((_) async{
                        await context.read<Homescreenprovider>().fetchEmotionHistory();
                      });
                    },
                    child: Row(
                      spacing: 5.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 19.6.h,
                          width: 16.w,
                          child: SvgPicture.asset(
                            "assets/images/mic_icon_black.svg",                        
                          ),
                        ),
                        Text("Start Voice Analysis",style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black
                        ),),
                      ],
                    ),                    
                  ),
                ):SizedBox.shrink(),
                analyzingProvider.analysistype=="face"?
                Container(      
                  width: double.infinity,
                  height: 51.h,       
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColers.primaryColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: MaterialButton( 
                    padding: EdgeInsets.all(8),
                    onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen(),));
                        WidgetsBinding.instance.addPostFrameCallback((_) async{
                          await context.read<Homescreenprovider>().fetchEmotionHistory();
                        });
                    },
                    child: Text("See Results",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                    ),),                    
                  ),
                ):SizedBox.shrink(),
                SizedBox(height: 24.h,),
            
                Consumer<AnalyzingProvider>(
                  builder: (context,val,child) {
                    return Container(      
                      width: double.infinity,
                      height: 51.h,       
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColers.primaryColor,
                          width: 2.w
                        )
                      ),
                      child: Consumer<PhotoAnalysisProvider>(
                        builder: (context,val2,child) {
                          return MaterialButton( 
                            padding: EdgeInsets.all(8),
                            onPressed:(){
                              WidgetsBinding.instance.addPostFrameCallback((_) async{
                                await context.read<Homescreenprovider>().fetchEmotionHistory();
                              });
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(),),(route) => false,);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StartPhotoScanScreen(),));
                              val.selctedimage=null;
                              val2.clearSelectedImage();
                            },
                            child: Row(
                              spacing: 5.w,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 22.h,
                                  width: 22.w,
                                  child: SvgPicture.asset(
                                    "assets/images/face_scan_icon.svg",                        
                                  ),
                                ),
                                Text("Scan a New Photo",style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onSecondary
                                ),),
                              ],
                            ),                    
                          );
                        }
                      ),
                    );
                  }
                ),
                
                
              ],
            );
          }
        ),
      ),
    );
  }
}