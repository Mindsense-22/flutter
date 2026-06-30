import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/emotion_history_wid.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/emotion_report_summary_wid.dart';

class MoreInfoScreen extends StatelessWidget {
  const MoreInfoScreen({super.key});
  
  @override
  Widget build(BuildContext context) {    
    return 
      
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [            
          
          const EmotionReportSummaryWid(),
          SizedBox(height: 0.h),
          Text(
            "Recent Activity",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          const EmotionHistoryWid(),
          SizedBox(height: 40.h),
        ],
      );    
  }
}