// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
// import 'package:mindsense_app/features/home/ui/widgets/currentstate_totalscans_wid.dart';
// import 'package:mindsense_app/features/home/ui/widgets/emogiessectionwid.dart';
// import 'package:mindsense_app/features/home/ui/widgets/exercisewid.dart';
// import 'package:mindsense_app/features/home/ui/widgets/homescreenbuttom.dart';
// import 'package:mindsense_app/features/home/ui/widgets/statusbarwidget.dart';
// import 'package:mindsense_app/features/home/ui/widgets/tipwid.dart';
// import 'package:provider/provider.dart';

// class Homescreen extends StatelessWidget {
//   const Homescreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(      
//       body: RefreshIndicator(
//         color: const Color(0xffA78BFA), // Color of the refresh spinner (matching your theme)
//         backgroundColor: const Color(0xff1E293B), // Background of the spinner indicator
//         onRefresh: () async {
          
//           await context.read<Homescreenprovider>().fetchEmotionHistory();
//         },
//         child: SingleChildScrollView(
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
//               child: Column(
//                 children: [
//                   Statusbarwidget(),
//                   SizedBox(height: 25.h,),
//                   //Emogiessectionwid(),
//                   CurrentstateTotalscansWid(),
//                   SizedBox(height: 26.h,),
//                   Tipwid(),
//                   SizedBox(height: 24.h,),
//                   Exercisewid(),
//                   SizedBox(height: 18.h,),
//                   Homescreenbuttom(),
//                   SizedBox(height: 16.h,),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:mindsense_app/features/home/ui/widgets/currentstate_totalscans_wid.dart';
import 'package:mindsense_app/features/home/ui/widgets/exercisewid.dart';
import 'package:mindsense_app/features/home/ui/widgets/homescreenbuttom.dart';
import 'package:mindsense_app/features/home/ui/widgets/statusbarwidget.dart';
import 'package:mindsense_app/features/home/ui/widgets/tipwid.dart';
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
            // Triggers API call on swipe down
            await context.read<Homescreenprovider>().fetchEmotionHistory();
          },
          child: SingleChildScrollView(
            // CRITICAL FIX: Ensures pull-to-refresh works even if screen content is short
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              // FIXED: Scaled padding with ScreenUtil
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
              child: Column(
                children: [
                  const Statusbarwidget(),
                  SizedBox(height: 25.h),
                  
                  // --- Main Widgets ---
                  const CurrentstateTotalscansWid(),
                  SizedBox(height: 22.h),
                  
                  const Tipwid(),
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
