import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommnetsScreen extends StatelessWidget {
  const CommnetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => Container(),
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  itemCount: 12,
                ),
              ),
        
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  height: 60.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff1E293B),
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Write a comment...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}