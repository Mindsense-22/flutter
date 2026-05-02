import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:provider/provider.dart';

class EmotionHistoryWid extends StatelessWidget {
  const EmotionHistoryWid({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.emotionHistory.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColers.primaryColor));
        }

        if (provider.error != null && provider.emotionHistory.isEmpty) {
          return Center(
            child: Text(
              provider.error!,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          );
        }

        if (provider.emotionHistory.isEmpty) {
          return _buildEmptyState();
        }
        return         
         Container(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff3DCADC).withAlpha(30),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 15.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.emotionHistory.length ,//> 5 ? 5 : provider.emotionHistory.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white.withAlpha(20),
                  height: 20.h,
                ),
                itemBuilder: (context, index) {
                  final item = provider.emotionHistory[index];
                  return _buildHistoryItem(item);
                },
              ),
              // if (provider.emotionHistory.length > 5)
              //   Padding(
              //     padding: EdgeInsets.only(top: 10.h),
              //     child: Center(
              //       child: TextButton(
              //         onPressed: () {
              //           // Navigate to full history screen if needed
              //         },
              //         child: Text(
              //           "See All History",
              //           style: TextStyle(
              //             color: AppColers.primaryColor,
              //             fontSize: 14.sp,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: AppColers.primaryColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: const Center(
            child: Icon(
              Icons.history,
              color: AppColers.primaryColor,
              size: 24,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          "Emotion History",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),        
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final String state = item['state'] ?? 'Unknown';
    final String source = item['source'] ?? 'unknown';
    final double confidence = (item['confidence'] as num?)?.toDouble() ?? 0.0;
    final String dateStr = item['createdAt'] ?? '';
    
    DateTime? date;
    if (dateStr.isNotEmpty) {
      date = DateTime.tryParse(dateStr)?.toLocal();
    }

    final formattedDate = date != null 
        ? DateFormat('MMM d, h:mm a').format(date)
        : 'Unknown Date';

    return Row(
      children: [
        _buildSourceIcon(source),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formattedDate,
                style: TextStyle(
                  color: Colors.white.withAlpha(150),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${(confidence * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                color: AppColers.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Confidence",
              style: TextStyle(
                color: Colors.white.withAlpha(100),
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSourceIcon(String source) {
    IconData icon;
    Color color;

    switch (source.toLowerCase()) {
      case 'face':
        icon = Icons.face;
        color = Colors.orangeAccent;
        break;
      case 'voice':
        icon = Icons.mic;
        color = Colors.blueAccent;
        break;
      case 'fusion':
        icon = Icons.psychology;
        color = Colors.purpleAccent;
        break;
      default:
        icon = Icons.analytics;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(Icons.history_toggle_off, color: Colors.white.withAlpha(100), size: 40),
          SizedBox(height: 10.h),
          Text(
            "No history available yet",
            style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
