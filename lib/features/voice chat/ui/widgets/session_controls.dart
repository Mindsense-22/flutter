import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/features/voice%20chat/logic/voicechat_provider.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:mindsense_app/features/voice%20chat/ui/widgets/session_summary_modal.dart';

class SessionControls extends StatefulWidget {
  const SessionControls({super.key});

  @override
  State<SessionControls> createState() => _SessionControlsState();
}

class _SessionControlsState extends State<SessionControls> {
  bool _isRecording = false;
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onStartSession() {
    context.read<VoicechatProvider>().startSession(emotion: "Neutral");
  }

  void _onStopSession() async {
    if (_isRecording) {
      await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
    }
    if (!mounted) return;
    final provider = context.read<VoicechatProvider>();
    await provider.endSession();
    if (!mounted) return;
    final summaryData = provider.sessionSummaryData;
    if (summaryData != null) {
      await SessionSummaryModal.show(context, summaryData);
    }
    if (!mounted) return;
    // Reset everything back to default after modal is closed
    provider.reset();
  }

  void _onPointerDown(PointerDownEvent event) async {
    if (await _audioRecorder.hasPermission()) {
      setState(() {
        _isRecording = true;
      });
      final path = '${Directory.systemTemp.path}/voice_msg_${DateTime.now().millisecondsSinceEpoch}.wav';
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: path,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Microphone permission required")),
        );
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) async {
    if (!_isRecording) return;
    
    setState(() {
      _isRecording = false;
    });
    
    final path = await _audioRecorder.stop();
    if (path != null) {
      File audioFile = File(path);
      if (mounted) {
        context.read<VoicechatProvider>().sendMessage(audioFile: audioFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VoicechatProvider>();
    final isSessionActive = provider.sessionId != null;

    if (!isSessionActive) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "READY TO TALK",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          InkWell(
            onTap: provider.isLoading ? null : _onStartSession,
            borderRadius: BorderRadius.circular(30.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                // gradient: const LinearGradient(
                //   colors: [DarkThemeColors.primaryColor, Color(0xff2B9889)], // Gradient teal
                // ),
                color:AppColers.primaryColor,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  provider.isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : Icon(Icons.mic_none, color: Colors.black, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Start Session",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _isRecording ? "RECORDING..." : provider.isLoading ? "THINKING..." : "LISTENING",
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 32.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mic button
            Listener(
              onPointerDown: _onPointerDown,
              onPointerUp: _onPointerUp,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isRecording ? 70.w : 64.w,
                height: _isRecording ? 70.w : 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffF04E5F), // vibrant coral/red
                  boxShadow: _isRecording
                      ? [
                          BoxShadow(
                            color: const Color(0xffF04E5F).withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ]
                      : [],
                ),
                child: Icon(
                  Icons.mic_none,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ),
            SizedBox(width: 24.w),
            // Stop button
            InkWell(
              onTap: _onStopSession,
              borderRadius: BorderRadius.circular(32.r),
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Icon(
                  Icons.stop_rounded,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Text(
          "Hold microphone button to speak",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }
}
