import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/voice%20chat/logic/voicechat_provider.dart';
import 'package:mindsense_app/features/voice%20chat/ui/voicechatsettings_screen.dart';
import 'package:provider/provider.dart';

class VoiceHeader extends StatelessWidget {
  const VoiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Consumer<VoicechatProvider>(
              builder: (context,val,child) {
                String quotaStr = val.quota ?? SharedPreferencesitem.getString("voiceQuota") ?? " ";
                if (quotaStr.length > 6) {
                  quotaStr = quotaStr.substring(0, 8);
                }
                return Text(
                  "Remaining: $quotaStr mins",
                  style: TextStyle(
                    color: DarkThemeColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VoicechatsettingsScreen(),));
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
              shape: const CircleBorder(),
            ),
          )
        ],
      ),
    );
  }
}
