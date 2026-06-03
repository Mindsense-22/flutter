import 'dart:developer';
import 'dart:io';

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
    return PopScope(
       canPop: true,      
      onPopInvokedWithResult: (didPop, result) {        
        Provider.of<PhotoAnalysisProvider>(context, listen: false)
        .clearSelectedImage();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Analyze Image ",style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),),
          centerTitle: true,
        ),
      
        body: Consumer<PhotoAnalysisProvider>(
          builder: (context,val,child) {
            
            return Padding(
              padding: EdgeInsets.symmetric(horizontal:20.w),
              child: Column(              
                
                children: [
                  SizedBox(
                    height: 55.h,
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

                  val.selctedimage != null?
                  Column(
                    children: [
                      SizedBox(height: 65.h,),                      
                      Container(
                        width: double.infinity,
                        height: 270.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Optional placeholder color while loading
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(
                            color: AppColers.primaryColor, // Fixed typo from AppColers if needed
                            width: 1.7.w,
                          ),
                          image: DecorationImage(
                            image: FileImage(File(val.selctedimage!.path)),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),                      
                    ],
                  )
                   
                  :SizedBox(height: 270.h,),           
                  SizedBox(height: 20.h,),
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
                    height: 25.h,
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
                                var provider=context.read<AnalyzingProvider>();
                                if(provider.analysistype=="face"){
                                  if(val.selctedimage!=null && !val.isloading){
                                  val2.submitFaceAnalysis(context);
                                  }
                                  else{
                                    log("error");
                                  }
                                }
                                if(val.selctedimage!=null && !val.isloading&&provider.analysistype=="all"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PhotoScanResultScreen()),
                                  );
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
      ),
    );
  }
}