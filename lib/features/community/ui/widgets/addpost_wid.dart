import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/features/community/logic/community_provider.dart';
import 'package:provider/provider.dart';

class AddpostWid extends StatefulWidget {
  const AddpostWid({super.key});

  @override
  State<AddpostWid> createState() => _AddpostWidState();
}

class _AddpostWidState extends State<AddpostWid> {
  String _intention = 'reflection';
  final List<String> _intentions = [
    'reflection',
    'achievement',
    'progress',
    'challenge update',
    'encouragement',
    'question'
  ];

  String _visibility = 'Nickname';
  final List<String> _visibilities = ['Nickname', 'Anonymous', 'Public'];

  String _audience = 'Global';
  final List<String> _audiences = [
    'Global',
    'Consistency',
    'Focus Circle',
    'Sleep Circle',
    'Stress Management',
    'Study Circle'
  ];

  final TextEditingController _contentController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {
        _charCount = _contentController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Widget _buildDropdown(
      String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xff1E293B),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 18.sp),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff0F172A), 
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share with intention',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '$_charCount/1200',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Reflection, progress, questions, and encouragement only.',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildDropdown(_intention, _intentions, (val) {
                if (val != null) setState(() => _intention = val);
              }),
              _buildDropdown(_visibility, _visibilities, (val) {
                if (val != null) setState(() => _visibility = val);
              }),
              _buildDropdown(_audience, _audiences, (val) {
                if (val != null) setState(() => _audience = val);
              }),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff1E293B),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: TextField(
              controller: _contentController,
              maxLines: 5,
              maxLength: 1200,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: 'What would be useful, honest, or encouraging to share today?',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                counterText: '', 
                contentPadding: EdgeInsets.all(16.w),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'No diagnosis, medical advice, spam, or sensitive state exposure.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              
              Consumer<CommunityProvider>(
                builder: (context, provider, child) {
                  return MaterialButton(
                    onPressed: provider.postisLoading ? null : () async {
                      if (_contentController.text.trim().isEmpty) {
                        customSnackbar(context, true, 'Content cannot be empty');                        
                        return;
                      }
                      
                      bool success = await provider.addPost(
                        type: _intention,
                        content: _contentController.text.trim(),
                        visibility: _visibility,
                        circleId: _audience,
                      );
                      
                      if (success && context.mounted) {
                        Navigator.pop(context);
                        customSnackbar(context, false, "Post Added");
                      } else if (!success && provider.error != null && context.mounted) {
                        customSnackbar(context, true, provider.error??"Error");
                        
                      }
                    },
                    color: const Color(0xff55EEDA),
                    disabledColor: const Color(0xff55EEDA).withValues(alpha: 0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    child: provider.postisLoading
                        ? SizedBox(
                            height: 18.h,
                            width: 18.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Post',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, 
                            ),
                          ),
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }
}