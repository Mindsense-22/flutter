import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindsense_app/features/exercises/logic/audio_player_provider.dart';
import 'package:mindsense_app/features/exercises/logic/exercises_provider.dart';
import 'package:provider/provider.dart';

class BetterSleepWid extends StatelessWidget {
  const BetterSleepWid({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    return Consumer<ExercisesProvider>(
      
      builder: (context,val,child) {
        return 
        ListView.builder(
          itemCount: val.bettersleepList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {


            return Padding(
              padding:EdgeInsets.only(right: 12.0.w),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      //color: Color(0xFF1E1B4B),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF1E1B4B), // deep indigo - left
                          Color(0xFF0F172A), // dark navy  - right
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ── Left: cover art + text info ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Cover art
                            
                            Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),                          
                              ),
                              child: CachedNetworkImage(
                                width: 75.w,
                                height: 75.h,
                                imageUrl: val.bettersleepList[index].onlinePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Title + metadata
                            SizedBox(
                              width: 143.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Title
                                  Text(
                                    val.bettersleepList[index].name,
                                    style: TextStyle(                                      
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      height: 20 / 14,
                                      color: const Color(0xFFF8FAFC),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  // Meta row: duration + type
                                  Row(
                                    children: [
                                      // Clock + duration
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/clock_icon.svg',
                                            width: 16.w,
                                            height: 16.h,
                                            
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "${val.bettersleepList[index].duration.toString()} Minutes",                                            
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 8.sp,
                                              height: 1.4,
                                              color: const Color(0xFFFAFAFA),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 4.w),
                                      // Headset + session type
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/headset.svg',
                                            width: 16.w,
                                            height: 16.h,
                                            
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            'Audio Session',
                                            style: TextStyle(                                              
                                              fontWeight: FontWeight.w400,
                                              fontSize: 8.sp,
                                              height: 1.4,
                                              color: const Color(0xFFFAFAFA),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  
                        // ── Right: play button ──
                        // InkWell(
                        //   borderRadius: BorderRadius.circular(200.r),
                        //   splashColor: Colors.white,
                        //   onTap: () {
                        //     context.read<AudioProvider>().play(
                        //       val.bettersleepList[index].audioonlinePath,
                        //     );
                        //   },
                        //   // onTap: () {
                        //   //   val.bettersleepList[index].mediaIsPlaying=!val.bettersleepList[index].mediaIsPlaying;
                        //   //   log(val.bettersleepList[index].mediaIsPlaying.toString());
                        //   // },
                        //   child: Consumer<AudioProvider>(
                        //     builder: (context,audio,child) {
                        //       final isCurrent =audio.currentUrl == val.bettersleepList[index].audioonlinePath;
        
                        //       return Container(
                        //         width: 48.w,
                        //         height: 48.h,
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           color: const Color(0xFFA855F7).withValues(alpha: 0.15),
                        //         ),
                        //         child: Center(
                        //           child: 
                        //           SvgPicture.asset(
                        //             isCurrent && audio.isPlaying?
                        //             'assets/images/headset.svg':
                        //             'assets/images/icon-play-sleep2.svg',
                        //             width: 24.w,
                        //             height: 24.h,
                                    
                        //           ) ,
                        //         ),
                        //       );
                        //     }
                        //   ),
                        // ),
                        InkWell(
                          borderRadius: BorderRadius.circular(200.r),
                          splashColor: Colors.white,
                          onTap: () {
                            val.bettersleepList[index].mediaIsPlaying=!val.bettersleepList[index].mediaIsPlaying;
                            val.changeisAudioPlaying(val.bettersleepList[index].mediaIsPlaying);
                            context.read<AudioProvider>().play(
                              val.bettersleepList[index].audioonlinePath,
                            );
                          },
                          // onTap:() {
                          //   audioProvider.play(val.bettersleepList[index].audioonlinePath);

                          // },

                          child: Consumer<AudioProvider>(
                            builder: (context, audio, child) {
                              final url = val.bettersleepList[index].audioonlinePath;

                              final isActive = audio.currentUrl == url;
                              final isPlaying = audio.isPlaying;

                              return Container(
                                width: 48.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFA855F7).withValues(alpha: 0.15),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    (isActive && isPlaying)
                                        ? 'assets/images/audio_pause_button.svg'
                                        : 'assets/images/icon-play-sleep2.svg',
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),              
            );
          },          
        );


      }
    );
  }
}