import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/exercises/logic/exercises_provider.dart';
import 'package:mindsense_app/features/exercises/ui/widgets/better_sleep_wid.dart';
import 'package:mindsense_app/features/exercises/ui/widgets/quick_relife_wid.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:provider/provider.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

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
            "Exercises",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: Theme.of(context).colorScheme.onSecondary
            ),
          ),
          centerTitle: true,
        ),
      
        body: SingleChildScrollView(
          child: Padding(
            padding:EdgeInsets.only(left: 12.w),
            child: Consumer<ExercisesProvider>(
              builder: (context,val,child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SizedBox(height: 577.h,),
                    Text(
                      "Quick Relief",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    SizedBox(
                      height:242.h,
                      width: double.infinity,
                      child: QuickRelifeWid()
                    ),
                    SizedBox(height: 24.h,),
                    Text(
                      "Better Sleep",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSecondary
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    //last widget here
                    BetterSleepWid()
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}