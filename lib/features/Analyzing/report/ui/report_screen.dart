import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/start_photo_scan_screen.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/widgets/imageanalysis_report_wid.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/widgets/overallstate_wid.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/widgets/voiceanalysis_report_wid.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analysis Report",style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSecondary
        ),),
        centerTitle: true,
      ),
    
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal:  20.0.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.h,),
              OverallstateWid(),
              SizedBox(height: 20.h,),
              ImageanalysisReportWid(),
              SizedBox(height: 20.h,),
              VoiceanalysisReportWid(),
              SizedBox(height: 32.h,),
    
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
                    
                  },
                  child: Text("Get Recommendation",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                  ),),                    
                ),
              ),
              SizedBox(height: 20.h,),
    
              Container(      
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
                child: MaterialButton( 
                  padding: EdgeInsets.all(8),
                  onPressed:(){
                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MainScreen(),),(route) => false,);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StartPhotoScanScreen(),));
                    
                  },
                  child:Text("Restart Analysis",style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSecondary
                  ),),                    
                ),
              ),
              SizedBox(height: 20.h,),
              Consumer<AnalyzingProvider>(
                builder: (context,val,child) {
                  return Container(      
                    width: double.infinity,
                    height: 51.h,       
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: MaterialButton( 
                      padding: EdgeInsets.all(8),
                      onPressed:(){
                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MainScreen(),),(route) => false,);
                        PaintingBinding.instance.imageCache.clear();
                        val.selctedimage=null;
                      },
                      child: Text("End Analysis",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color:Theme.of(context).colorScheme.onSecondary
                      ),),                    
                    ),
                  );
                }
              ),
              SizedBox(height: 23.h,),

    
            ],
          ),
        ),
      ),
    );
  }
}