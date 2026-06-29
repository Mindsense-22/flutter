import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/start_photo_scan_screen.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/ui/start_voice_scan_screen.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class ChossenScreen extends StatelessWidget {
  const ChossenScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
      WidgetsBinding.instance.addPostFrameCallback((_) async{
        
       await  context.read<Homescreenprovider>().fetchEmotionHistory();
      });
    }
      },
      child: Scaffold(
        backgroundColor: DarkThemeColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Analysis Type",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async{
              Navigator.pop(context);
              await  context.read<Homescreenprovider>().fetchEmotionHistory(); 
            } ,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h,),
                Text(
                  "How would you like to analyze your current state?",
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),
                
                _buildAnalysisCard(
                  context: context,
                  title: "Face Analysis",
                  description: "Analyze your facial expressions to detect emotions.",
                  icon: Icons.face_retouching_natural,
                  onTap: () {
                    Provider.of<AnalyzingProvider>(context, listen: false)
                        .changeAnalysingType("face");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StartPhotoScanScreen()));
                  },
                ),
                SizedBox(height: 20.h),
                
                _buildAnalysisCard(
                  context: context,
                  title: "Voice Analysis",
                  description: "Analyze your voice tone and pitch for emotional cues.",
                  icon: Icons.mic_none_outlined,
                  onTap: () {
                    Provider.of<AnalyzingProvider>(context, listen: false)
                        .changeAnalysingType("voice");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StartVoiceScanScreen()));
                  },
                ),
                SizedBox(height: 20.h),
                
                _buildAnalysisCard(
                  context: context,
                  title: "Comprehensive Analysis",
                  description: "Combine both face and voice for the most accurate results.",
                  icon: Icons.analytics_outlined,
                  isPremium: true,
                  onTap: () {
                    Provider.of<AnalyzingProvider>(context, listen: false)
                        .changeAnalysingType("all");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StartPhotoScanScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 10.w),
        decoration: BoxDecoration(
          color: const Color(0xff1E293B),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isPremium ? AppColers.primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
            width: isPremium ? 1.5 : 1,
          ),
          boxShadow: [
            if (isPremium)
              BoxShadow(
                color: AppColers.primaryColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isPremium ? AppColers.primaryColor.withOpacity(0.2) : Colors.blueAccent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28.sp,
                color: isPremium ? AppColers.primaryColor : Colors.blueAccent,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (isPremium) ...[
                        SizedBox(width: 8.w),
                        Icon(Icons.star, color: AppColers.primaryColor, size: 16.sp),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[400],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}