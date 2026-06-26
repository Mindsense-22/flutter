import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/mood_distribution_chart.dart';
import 'package:provider/provider.dart';

class EmotionReportSummaryWid extends StatelessWidget {
  const EmotionReportSummaryWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        // if (provider.isLoading && provider.emotionReport.isEmpty) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_buildSummaryCard(provider),
            //SizedBox(height: 25.h),
            //const MoodDistributionChart(),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(DashboardProvider provider) {
    final totalEntries = provider.emotionReport.length;
    final dominantMood = _getDominantMood(provider.emotionReport);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff3DCADC), Color(0xff55EEDA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff55EEDA).withAlpha(100),
            blurRadius: 15.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // for happy
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " Overall Outlook",
                style: TextStyle(
                  color: Colors.black.withAlpha(150),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                provider.emotionReport.isEmpty?"Primarily happy":
                "Primarily ${(provider.emotionReport[0]["_id"]["state"])??"happy"}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 100.w,
                children: [
                  provider.emotionReport.isNotEmpty?
                  _buildSimpleStat("Total Scans", provider.emotionReport[0]["count"]??"0"):SizedBox.shrink(), 
                  provider.emotionReport.isNotEmpty?               
                  _buildSimpleStat("Confidence", "${((provider.emotionReport[0]["avgConfidence"] * 10)??0).toStringAsFixed(0)}%")                  
                  :SizedBox.shrink()
                ],
              ),
            ],
          ),

          // for sad
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overall Outlook",
                style: TextStyle(
                  color: Colors.black.withAlpha(150),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                provider.emotionReport.isEmpty?"Primarily Sad":
                "Primarily ${(provider.emotionReport[1]["_id"]["state"])??"happy"}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 100.w,
                children: [
                  provider.emotionReport.isNotEmpty?
                  _buildSimpleStat("Total Scans", provider.emotionReport[1]["count"]??"0"):SizedBox.shrink(), 
                  provider.emotionReport.isNotEmpty?               
                  _buildSimpleStat("Confidence", "${((provider.emotionReport[1]["avgConfidence"] * 10)??0).toStringAsFixed(0)}%")                  
                  :SizedBox.shrink()
                ],
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String value) {   
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(         
          label,
          style: TextStyle(
            color: Colors.black.withAlpha(120),
            fontSize: 12.sp,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getDominantMood(List<dynamic> report) {
    if (report.isEmpty) return "Calm";
    final Map<String, int> counts = {};
    for (var item in report) {
      final String state = item['_id']?['state'] ?? 'Unknown';
      final int count = item['count'] ?? 0;
      counts[state] = (counts[state] ?? 0) + count;
    }
    if (counts.isEmpty) return "Calm";
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
