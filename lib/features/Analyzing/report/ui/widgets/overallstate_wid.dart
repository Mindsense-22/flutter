import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/report/logic/analysisreportprovider.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/report_screen.dart';
import 'package:mindsense_app/features/Analyzing/report/ui/widgets/animated_circle_progress_wid.dart';
import 'package:mindsense_app/features/Analyzing/widgets/reportadvices_wid.dart';
import 'package:provider/provider.dart';

class OverallstateWid extends StatelessWidget {
  const OverallstateWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyzingProvider>(
      builder: (context,analyzingprovider,child) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xff1E293B),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF67B6F7).withValues(alpha: 0.2),
                blurRadius: 8.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Overall State",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 50.h,),
              Consumer<AnalyzingProvider>(
                builder: (context,val,child) {
                  return AnimatedCircleProgress(target: val.finalScore!,state: val.detectedEmotion!,);
                }
              ),
              SizedBox(height: 50.h,),
              // ── Recommended Exercises Title ──
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          'Recommended ',
                          style: TextStyle(                
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppColers.primaryColor,
                            height: 1.5625,
                          ),
                        ),
                      ),
                  
                      SizedBox(height: 8.h),
                      
                      ReportadvicesWid(shownAdvice: analyzingprovider.shownAdvice,),
        
            ],
          ),
        );
      }
    );
  }
}