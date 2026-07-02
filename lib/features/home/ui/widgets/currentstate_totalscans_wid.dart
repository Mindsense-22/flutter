import 'package:flutter/material.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentstateTotalscansWid extends StatelessWidget {
  const CurrentstateTotalscansWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Homescreenprovider>(
      builder: (context, provider, _) {
        final String stateText = provider.currentstate.isEmpty ? "Analyzing..." : provider.currentstate;
        
        final double confidenceValue = provider.confidence;        
        final double progressValue = confidenceValue <= 1.0 ? confidenceValue : confidenceValue / 100;

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B), 
            borderRadius: BorderRadius.circular(24.r),            
          ),
          child: Row(
            children: [
              // --- LEFT: Current Mind State & Confidence ---
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "CURRENT MIND STATE",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff94A3B8), 
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      //stateText,
                      SharedPreferencesitem.getString("currentstate_home")==null?
                      stateText:SharedPreferencesitem.getString("currentstate_home")!,

                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    
                    // Confidence Level Block
                    Row(
                      children: [
                        Icon(
                          Icons.insights_rounded, 
                          size: 14.r, 
                          color: const Color(0xffA78BFA), 
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          //"Confidence: ${provider.confidence*100}%",
                          SharedPreferencesitem.getDouble("confidence_home")==null?
                          "Confidence: ${(provider.confidence * 100).toStringAsFixed(0)}%":
                          "Confidence: ${(SharedPreferencesitem.getDouble("confidence_home")! * 100).toStringAsFixed(0)}%",                          
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffA78BFA),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        //value: progressValue.clamp(0.0, 1.0),
                        value:SharedPreferencesitem.getDouble("confidence_home")==null? progressValue.clamp(0.0, 1.0):SharedPreferencesitem.getDouble("confidence_home")!.clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffA78BFA)),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              ),

              // --- MIDDLE: Divider ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 75.h,
                  width: 1.w,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),

              // --- RIGHT: Mind Scan Stats Counters ---
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: const Color(0xff38BDF8).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.psychology_rounded,
                        color: const Color(0xff38BDF8),
                        size: 24.r,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Total Scans",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff94A3B8),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      //"${provider.totalScans}",
                       SharedPreferencesitem.getInt("totalScans_home")==null?
                       "${provider.totalScans}":SharedPreferencesitem.getInt("totalScans_home")!.toString(),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}