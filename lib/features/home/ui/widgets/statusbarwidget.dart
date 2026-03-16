import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class Statusbarwidget extends StatelessWidget {
  const Statusbarwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColers.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(48))
          ),
          child: Icon(
            Icons.person_2,
            size: 48,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 8.w,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, here's",style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff7C9CD1)
              ),
            ),
            Text(
              "your status",style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white
              ),
            ),

          ],
        ),
        Spacer(),
        InkWell(
          onTap: () {
            
          },
          child: Container(
            width: 88.w,
            height: 26.h,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xff4D5DD3),
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/caricon.svg"
                ),
                Text(
                  " Drive Mode",style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}