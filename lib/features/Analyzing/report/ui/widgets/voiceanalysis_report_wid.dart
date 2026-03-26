import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/report/logic/analysisreportprovider.dart';
import 'package:provider/provider.dart';

class VoiceanalysisReportWid extends StatelessWidget {
  const VoiceanalysisReportWid({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Consumer<Analysisreportprovider>(
        builder: (context,val,child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header: Icon + Title ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Color(0xff55EEDA).withValues(alpha:0.15),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/images/mic-01.svg",
                          height: 20.h,
                          width: 20.w,
                        )
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Voice Analysis',
                      style: TextStyle(                        
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          
              SizedBox(height: 12.h),
          
              // ── Facial State ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      
                      fontSize: 16.sp,
                      color: Colors.white,
                      height: 1.5625,
                    ),
                    children: [
                      TextSpan(
                        text:'Your Voice state',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: ': ${val.voiceState}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
          
              SizedBox(height: 16.h),
          
              // ── Recommended Exercises Title ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  'Recommended Exercises',
                  style: TextStyle(                
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColers.primaryColor,
                    height: 1.5625,
                  ),
                ),
              ),
          
              SizedBox(height: 8.h),
          
              // ── Dynamic Exercise List ──
              ...val.voiceAnalysisExercises.map(
                (exercise) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _ExerciseVoiceItem(text: exercise),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

// ── Private bullet item widget ──
class _ExerciseVoiceItem extends StatelessWidget {
  final String text;
  const _ExerciseVoiceItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 9.h),
            child: Icon(Icons.circle, size: 6.sp, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
                color: Colors.white,
                height: 1.5625,
              ),
            ),
          ),
        ],
      ),
    );
  }
}