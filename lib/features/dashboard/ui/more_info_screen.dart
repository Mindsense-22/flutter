import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/emotion_history_wid.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/emotion_report_summary_wid.dart';
import 'package:provider/provider.dart';

class MoreInfoScreen extends StatelessWidget {
  const MoreInfoScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    var provider=context.watch<DashboardProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Insights & History",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<DashboardProvider>().refreshData(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 20.h),
        child:
        provider.isLoading==false?
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
        ):Center(
              child: Column(
                children: [
                  CircularProgressIndicator()
                ],
              ),
            )
      ),
    );
  }
}