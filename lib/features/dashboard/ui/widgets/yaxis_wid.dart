import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

  @override
 class YAxis extends StatelessWidget {
  const YAxis({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final value = (100 - index * 20);
    
        return Text(
          value.toString(),
          style: TextStyle(
            color: const Color(0xFFcecece),
            fontSize: 12.sp,
            fontFamily: 'Poppins',
          ),
        );
      }),
    );
  }
}
