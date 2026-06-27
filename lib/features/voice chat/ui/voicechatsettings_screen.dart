import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/voice%20chat/logic/voicechat_provider.dart';
import 'package:provider/provider.dart';

class VoicechatsettingsScreen extends StatefulWidget {
  const VoicechatsettingsScreen({super.key});

  @override
  State<VoicechatsettingsScreen> createState() => _VoicechatsettingsScreenState();
}

class _VoicechatsettingsScreenState extends State<VoicechatsettingsScreen> {
  String _preferredLanguage = "english";
  bool _autoDetect = false;
  String _voiceStyle = "calm";
  double _speed = 80;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSettings();
    });
  }

  Future<void> _fetchSettings() async {
    final provider = context.read<VoicechatProvider>();
    await provider.fetchSettings();
    if (!mounted) return;
    if (provider.settings != null) {
      setState(() {
        _preferredLanguage = provider.settings!['preferredLanguage'] ?? "english";
        _autoDetect = provider.settings!['autoDetect'] ?? false;
        _voiceStyle = provider.settings!['voiceStyle'] ?? "calm";
        _speed = (provider.settings!['speed'] ?? 80).toDouble();
      });
    }
  }

  Future<void> _saveSettings() async {
    final provider = context.read<VoicechatProvider>();
    await provider.updateSettings(
      preferredLanguage: _preferredLanguage,
      autoDetect: _autoDetect,
      voiceStyle: _voiceStyle,
      speed: _speed,
    );
    if (!mounted) return;
    if (provider.errorMessage == null) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  Future<void> _previewVoice() async {
    final provider = context.read<VoicechatProvider>();
    await provider.previewSettings(
      preferredLanguage: _preferredLanguage,
      voiceStyle: _voiceStyle,
      speed: _speed,
    );
    if (!mounted) return;
    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<VoicechatProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xff121A32), 
      appBar: AppBar(
        centerTitle: true,
        
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Voice Settings",
          style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: DarkThemeColors.primaryColor))
        : SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Preferred language"),
                SizedBox(height: 8.h),
                _buildDropdown(
                  value: _preferredLanguage,
                  items: const {
                    "english": "US English",
                    "egyptian_arabic": "Egyptian Arabic",                    
                  },
                  onChanged: (val) {
                    if (val != null) setState(() => _preferredLanguage = val);
                  },
                ),
                SizedBox(height: 24.h),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Checkbox(
                        value: _autoDetect,
                        onChanged: (val) {
                          if (val != null) setState(() => _autoDetect = val);
                        },
                        activeColor: DarkThemeColors.primaryColor,
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.white70),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "Auto-detect language from speech",
                        style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "When off, the companion always listens and replies in your chosen language only.",
                  style: TextStyle(color: Colors.white54, fontSize: 13.sp, height: 1.4),
                ),
                SizedBox(height: 24.h),

                _buildLabel("Voice style"),
                SizedBox(height: 8.h),
                _buildDropdown(
                  value: _voiceStyle,
                  items: const {
                    "calm": "Calm (male)",
                    "warm": "warm (female)",                    
                  },
                  onChanged: (val) {
                    if (val != null) setState(() => _voiceStyle = val);
                  },
                ),
                SizedBox(height: 24.h),

                _buildLabel("Speech speed: ${_speed.toInt()}%"),
                SizedBox(height: 8.h),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: DarkThemeColors.primaryColor,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: DarkThemeColors.primaryColor,
                    trackHeight: 4.h,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
                  ),
                  child: Slider(
                    value: _speed,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    onChanged: (val) {
                      setState(() => _speed = val);
                    },
                  ),
                ),
                SizedBox(height: 24.h),

                OutlinedButton.icon(
                  onPressed: _previewVoice,
                  icon: const Icon(Icons.play_arrow_outlined, color: Colors.white),
                  label: Text(
                    "Preview voice",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    side: BorderSide(color: Colors.white.withOpacity(0.1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    backgroundColor: const Color(0xff1B2540),
                  ),
                ),
                
                SizedBox(height: 48.h),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                        backgroundColor: const Color(0xff1B2540),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DarkThemeColors.primaryColor,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildDropdown({
    required String value,
    required Map<String, String> items,
    required void Function(String?) onChanged,
  }) {
    // Ensure the value exists in the map to prevent dropdown errors
    final safeValue = items.containsKey(value) ? value : items.keys.first;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1B2540),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          isExpanded: true,
          dropdownColor: const Color(0xff1B2540),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          items: items.entries.map((e) {
            return DropdownMenuItem<String>(
              value: e.key,
              child: Text(
                e.value,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}