import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/styles/colors.dart';
import '../../logic/homescreenprovider.dart';

class Emogiessectionwid extends StatelessWidget {
  const Emogiessectionwid({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Consumer<Homescreenprovider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Text(
              "Select an emoji to reflect your",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "current mood.",
              style: TextStyle(
                color: AppColers.primaryColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(provider.emojis.length, (index) {
                bool isSelected = provider.selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    provider.changeSelectedIndex(index);                    
                    provider.changeImogiStatus(provider.emojis[index]["label"]!);
                    log(provider.imogistatus);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 75.w : 55.w,
                    height: isSelected ? 75.h : 55.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColers.primaryColor
                          : const Color(0xff2A3556),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          provider.emojis[index]["emojiPath"]!,  
                          width: 30.w ,
                          height: 30.h ,                 
                        ),                        
                        if (isSelected) ...[
                          SizedBox(height: 4.h),
                          Text(
                            provider.emojis[index]["label"]!,
                            style:  TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
