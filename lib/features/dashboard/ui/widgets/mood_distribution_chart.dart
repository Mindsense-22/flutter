import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:provider/provider.dart';

class MoodDistributionChart extends StatelessWidget {
  const MoodDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.emotionReport.isEmpty) {
          return const SizedBox.shrink();
        }

        // Aggregate counts by state
        final Map<String, int> distribution = {};
        int totalCount = 0;
        for (var item in provider.emotionReport) {
          final String state = item['_id']?['state'] ?? 'Unknown';
          final int count = item['count'] ?? 0;
          distribution[state] = (distribution[state] ?? 0) + count;
          totalCount += count;
        }

        if (totalCount == 0) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withAlpha(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mood Distribution",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              _buildProgressBar(distribution, totalCount),
              SizedBox(height: 25.h),
              _buildLegend(distribution),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(Map<String, int> distribution, int total) {
    return Container(
      height: 16.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Row(
          children: distribution.entries.map((entry) {
            final double percentage = entry.value / total;
            return Expanded(
              flex: (percentage * 100).toInt(),
              child: Container(
                color: _getColorForState(entry.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLegend(Map<String, int> distribution) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: distribution.length,
      itemBuilder: (context, index) {
        final entry = distribution.entries.elementAt(index);
        return Row(
          children: [
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: _getColorForState(entry.key),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                entry.key,
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 14.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              entry.value.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getColorForState(String state) {
    switch (state.toLowerCase()) {
      case 'happy':
        return const Color(0xff55EEDA);
      case 'sad':
        return Colors.blueAccent;
      case 'angry':
        return Colors.redAccent;
      case 'neutral':
        return Colors.grey;
      case 'stressed':
        return Colors.orangeAccent;
      case 'fear':
        return Colors.purpleAccent;
      default:
        return Colors.teal;
    }
  }
}
