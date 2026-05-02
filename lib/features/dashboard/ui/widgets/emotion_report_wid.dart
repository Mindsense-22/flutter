import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:provider/provider.dart';

class EmotionReportWid extends StatelessWidget {
  const EmotionReportWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.emotionReport.isEmpty) {
          return const SizedBox.shrink();
        }

        if (provider.emotionReport.isEmpty) {
          return const SizedBox.shrink();
        }

        // Group by emotion state to show overall distribution
        final Map<String, int> distribution = {};
        for (var item in provider.emotionReport) {
          final String state = item['_id']?['state'] ?? 'Unknown';
          final int count = item['count'] ?? 0;
          distribution[state] = (distribution[state] ?? 0) + count;
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff55EEDA).withAlpha(20),
                blurRadius: 8.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 15.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: distribution.entries.map((entry) {
                  return _buildStatChip(entry.key, entry.value);
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.purpleAccent.withAlpha(25),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: const Center(
            child: Icon(
              Icons.pie_chart,
              color: Colors.purpleAccent,
              size: 24,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          "Mood Distribution",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String state, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getStateIndicator(state),
          SizedBox(width: 8.w),
          Text(
            state,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColers.primaryColor.withAlpha(40),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: AppColers.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStateIndicator(String state) {
    Color color;
    switch (state.toLowerCase()) {
      case 'happy':
        color = Colors.greenAccent;
        break;
      case 'sad':
        color = Colors.blueAccent;
        break;
      case 'angry':
        color = Colors.redAccent;
        break;
      case 'neutral':
        color = Colors.grey;
        break;
      case 'stressed':
        color = Colors.orangeAccent;
        break;
      default:
        color = Colors.purpleAccent;
    }

    return Container(
      width: 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withAlpha(100), blurRadius: 4.r),
        ],
      ),
    );
  }
}
