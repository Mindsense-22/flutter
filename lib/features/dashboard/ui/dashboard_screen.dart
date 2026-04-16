import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/dashboard_info_wid.dart';
import 'package:mindsense_app/features/dashboard/ui/widgets/weekly_mood_wid.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        var provider=context.read<Mainscreenprovider>();
        provider.changeIndex(0);
        log(provider.index.toString());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: Theme.of(context).colorScheme.onSecondary
            ),
          ),
          centerTitle: true,
        ),
      
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 17.w),
          child: Column(
            children: [
              DashboardInfoWid(),
              SizedBox(height: 49.h,),
              // dashbord here
              SizedBox(height: 21.h,),
              WeeklyMoodWid(),
            ],
          ),
        ),
      ),
    );
  }
}