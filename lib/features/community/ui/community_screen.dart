import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/community/ui/widgets/addpost_shape.dart';
import 'package:mindsense_app/features/community/ui/widgets/addpost_wid.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 10.0.w),
          child: Column(
            children: [
              SizedBox(height:15.h),
              AddpostShape(),
            ],
          ),
        ),
      ),
    );
  }
}