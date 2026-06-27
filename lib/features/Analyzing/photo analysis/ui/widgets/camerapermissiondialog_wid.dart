import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/logic/photo_analysis_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CamerapermissiondialogWid extends StatelessWidget {
  const CamerapermissiondialogWid({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: AppColers.backgroundColor.withValues(alpha: .3),
            ),
          ),
      
          // Popup Card
          Center(
            child: Container(
              alignment: Alignment.center,
              width: 335.w,
              height: 318.h,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(                
                color: Color(0xff121A32),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 13,right: 13),
                child: Column(  
                  crossAxisAlignment: CrossAxisAlignment.center,                  
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: AppColers.primaryColor,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/cameraicon.svg",
                          width: 37.63.w,
                          height: 37.63.h,
                        ),                          
                      ),                
                    ), 
                    SizedBox(height: 20.h,),
                    Text(                      
                      "Please allow camera access so we can analyze your facial expressions.",
                      textAlign: TextAlign.center ,
                      style: TextStyle(                      
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,                        
                        color: Theme.of(context).colorScheme.onSecondary,                        
                      ),
                    ), 
                    SizedBox(height: 32.h,),

                    Row(
                      spacing: 20.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          height: 48.h,
                          width: 125.w,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(                            
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: AppColers.primaryColor,width: 2.w)
                          ),
                          child: MaterialButton(
                            elevation: 0,                            
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                "Cancel",                                
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ),                       

                        Consumer<PhotoAnalysisProvider>(
                          builder: (context,val,child) {
                            return Container(
                              height: 48.h,
                              width: 125.w,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColers.primaryColor,
                                borderRadius: BorderRadius.circular(10.r)
                              ),
                              child: MaterialButton(
                                elevation: 0,                            
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed:()async{                                                                     
                                  val.changeCameraPermission(true);
                                  Navigator.pop(context);    
                                  await Permission.camera.request();                                                               
                                },
                                child: Center(
                                  child: Text(
                                    "Allow",                                
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black
                                    ),
                                  ),
                                ), 
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),        
        ],
      ),
    );      
  }
}