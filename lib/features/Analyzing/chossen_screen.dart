import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/start_photo_scan_screen.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/start_voice_scan_screen.dart';
import 'package:provider/provider.dart';

class ChossenScreen extends StatelessWidget {
  const ChossenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chose Your Analysis Type",style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20.w),
        child: Column(
          spacing: 20.h,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton(
              onPressed:(){
                Provider.of<AnalyzingProvider>(context, listen: false)
                 .changeAnalysingType("face");
                Navigator.push(context, MaterialPageRoute(builder: (context) => StartPhotoScanScreen(),));

              } ,
              text: "Face Analysis",
            ),
        
            CustomButton(
              onPressed:(){
                Provider.of<AnalyzingProvider>(context, listen: false)
                 .changeAnalysingType("voice");
                Navigator.push(context, MaterialPageRoute(builder: (context) => StartVoiceScanScreen(),));

              } ,
              text: "Voice Analysis",
            ),
            CustomButton(
              onPressed:(){
                Provider.of<AnalyzingProvider>(context, listen: false)
                 .changeAnalysingType("all");
                Navigator.push(context, MaterialPageRoute(builder: (context) => StartPhotoScanScreen(),));

              } ,
              text: "All Analysis",
            ),
          ],
        ),
      ),
    );
  }
}