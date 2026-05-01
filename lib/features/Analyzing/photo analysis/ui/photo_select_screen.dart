import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/logic/photo_analysis_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/photo_scan_result_screen.dart';
import 'package:provider/provider.dart';

class PhotoSelectScreen extends StatelessWidget {
  const PhotoSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),

      body: Consumer<PhotoAnalysisProvider>(
        builder: (context,val,child) {
          
          return Padding(
            padding: EdgeInsets.symmetric(horizontal:20.w),
            child: Column(              
              
              children: [
                SizedBox(
                  height: 105.h,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Select An Image From Gallery Or Take It From Camera To start ",style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),),
                Text(
                  textAlign: TextAlign.center,
                  "Analyze It",style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColers.primaryColor,
                ),),                
                SizedBox(height: 95.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Image Status : ",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      val.selctedimage!=null?"Image Taken Successfully":"Not Taken Yet!",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: val.selctedimage!=null? AppColers.primaryColor:Colors.red,
                      ),
                    ),
                  ],
                ),
                

                

                SizedBox(
                  height: 135.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 25.w,
                  children: [

                    Container(
                      width: 152.w,
                      height: 51.h, 
                      decoration: BoxDecoration(
                        color: AppColers.backgroundColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColers.primaryColor,
                          width: 2.w
                        ),
                      ),
                      child: MaterialButton(
                        onPressed:(){
                          val.pickGalleryImage(context);
                        },
                        child: Text(
                          "Gallery",style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 152.w,
                      height: 51.h, 
                      decoration: BoxDecoration(
                        color: AppColers.backgroundColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColers.primaryColor,
                          width: 2.w
                        ),
                      ),
                      child: MaterialButton(
                        onPressed:(){
                          val.pickCameraImage(context);
                        },
                        child: Text(
                          "Camera",style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 25.h,),
                Consumer<AnalyzingProvider>(
                  builder: (context,val2,child) {
                    return
                     val2.isAnalyzing 
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: AppColers.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              :
                     Container(
                      width: double.infinity,
                      height: 51.h, 
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColers.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                        
                      ),
                      child:                           
                           MaterialButton(                    
                            onPressed:(){
                              if(val.selctedimage!=null && !val.isloading){
                                val2.submitFaceAnalysis(context);
                              }
                              else{
                                log("error");
                              }
                              
                            },
                            child:  Text(
                                "See Result",style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onPrimary
                                ),
                              ),
                          ),
                     );
                  }
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}