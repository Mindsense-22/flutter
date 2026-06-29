import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnalysisRequiredWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const AnalysisRequiredWidget({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:  EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
       
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Graphic
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.08),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                Icons.psychology_rounded,
                size: 38,
                color: Colors.blue.shade700,
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Text(
            "Analysis Required",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

           SizedBox(height: 12.h),

          Text(
            "Do your analysis first to receive personalized exercises tailored to your mental well-being.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey.shade300,
              height: 1.5.h,
            ),
          ),

          SizedBox(height: 15.h),
          
        ],
      ),
    );
  }
}