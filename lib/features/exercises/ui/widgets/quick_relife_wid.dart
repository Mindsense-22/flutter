import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/exercises/logic/exercises_provider.dart';
import 'package:provider/provider.dart';

class QuickRelifeWid extends StatelessWidget {
  const QuickRelifeWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExercisesProvider>(
      builder: (context,val,child) {
        return ListView.builder(
          itemCount: val.quickReliefsList.length,
          scrollDirection:Axis.horizontal,
          itemBuilder: (context, index) {
            return Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(13.r),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.transparent,
                  onTap: () {
                    
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    height:242.h,
                    width: 170.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Color(0xff1E293B)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.h,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r)
                          ),
                          child: CachedNetworkImage(
                            imageUrl: val.quickReliefsList[index].onlinePath,
                            fit: BoxFit.fill,
                            height: 165.h,
                            width: 154.w,
                          ),
                        ),
                        Text(
                          val.quickReliefsList[index].name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${val.quickReliefsList[index].duration.toString()} Minutes",
                          
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff94A3B8),
                          ),
                        ),                    
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w,)
              ],
            );
          },
        );
      }
    );
  }
}