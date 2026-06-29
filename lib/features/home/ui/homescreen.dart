import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:mindsense_app/features/home/ui/widgets/currentstate_totalscans_wid.dart';
import 'package:mindsense_app/features/home/ui/widgets/exercisewid.dart';
import 'package:mindsense_app/features/home/ui/widgets/homescreenbuttom.dart';
import 'package:mindsense_app/features/home/ui/widgets/statusbarwidget.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: SafeArea(       
        child: RefreshIndicator(
          color: AppColers.primaryColor, 
          backgroundColor: const Color(0xff1E293B), 
          onRefresh: () async {
            
            await context.read<Homescreenprovider>().fetchEmotionHistory();
            // ignore: use_build_context_synchronously
            await context.read<Homescreenprovider>().fetchIntervention();
          },
          child: SingleChildScrollView(            
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(              
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
              child: Column(
                children: [
                  const Statusbarwidget(),
                  SizedBox(height: 25.h),
                  
                  
                  const CurrentstateTotalscansWid(),
                  SizedBox(height: 22.h),
                                    
                  const Exercisewid(),
                  SizedBox(height: 22.h),
                  
                  const Homescreenbuttom(),
                  SizedBox(height: 22.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
