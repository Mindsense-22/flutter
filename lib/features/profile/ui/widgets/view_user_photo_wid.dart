  import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

Future<dynamic> messgeShowDialog(context){    
    return showDialog(
      context: context,
      builder: (context) {
        var provider=context.read<ProfileScreenProvider>();
        return Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
               //color: Colors.black.withOpacity(0.3),
                 color: AppColers.backgroundColor.withValues(alpha: .3),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Popup Card
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 335.h,
                  
                  decoration: BoxDecoration(                    
                    color: Colors.white,                    
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(  
                    crossAxisAlignment: CrossAxisAlignment.start,                  
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 335.h,
                            width: double.infinity,
                            child: 
                            Consumer<ProfileScreenProvider>(
                              builder: (context,val,child) {
                                if (val.avatarLink == null || val.avatarLink!.isEmpty) {
                                  return ClipRRect(
                                    clipBehavior: Clip.antiAlias,
                                    borderRadius: BorderRadiusGeometry.circular(20.r),
                                    child: CachedNetworkImage(
                                      imageUrl: "https://drive.google.com/uc?export=download&id=1HQGGxju316dlVBAE5NkTzAa5drUkEZDm",
                                      fit: BoxFit.cover,   
                                    ),
                                  );
                                }
                                return ClipRRect(
                                  borderRadius: BorderRadiusGeometry.circular(20.r),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl: ApiConstants.baseUrl + val.avatarLink!,
                                    fit: BoxFit.cover,   
                                  ),
                                );
                              }
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back,size: 25.h,color: Colors.black,),
                          ), 
                        ],
                      )                       
                      
                    ],
                  ),
                ),
              ),
            ),
          
          ],
        );
      }
    );
  }

