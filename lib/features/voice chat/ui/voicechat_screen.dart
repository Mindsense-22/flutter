import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/features/voice%20chat/logic/voicechat_provider.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/voice%20chat/ui/widgets/voice_header.dart';
import 'package:mindsense_app/features/voice%20chat/ui/widgets/pulsing_orb.dart';
import 'package:mindsense_app/features/voice%20chat/ui/widgets/session_controls.dart';
import 'package:mindsense_app/features/voice%20chat/ui/widgets/subtitle_box.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoicechatScreen extends StatelessWidget {
  const VoicechatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VoicechatProvider(),
      child: Scaffold(
        backgroundColor: DarkThemeColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const VoiceHeader(),
              Expanded(
                child: Consumer<VoicechatProvider>(
                  builder: (context, provider, child) {
                    final isSessionActive = provider.sessionId != null;
                    final isAnimating = isSessionActive || provider.isLoading;
                    
                    return Column(
                      children: [
                        // Glowing Orb — takes flexible space in the top half
                        Expanded(
                          child: Center(
                            child: PulsingOrb(isAnimating: isAnimating),
                          ),
                        ),
                        if (provider.lastResponseText != null)SizedBox(height: 30.h,),

                        // Bottom section — controls + subtitle, scrollable to avoid overflow
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Subtitle Box
                              if (provider.lastResponseText != null)
                                Column(
                                  children: [
                                    
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                                      child: SubtitleBox(text: provider.lastResponseText!),
                                    ),
                                   
                                  ],
                                ),
                              SizedBox(height: 24.h),
                              // Controls (Start Session or Mic/Stop)
                              const SessionControls(),
                              SizedBox(height: 50.h),

                              
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}