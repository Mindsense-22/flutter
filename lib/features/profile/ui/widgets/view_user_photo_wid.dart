  import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

Future<dynamic> messgeShowDialog(context){    
    return showDialog(
      context: context,
      builder: (context) {
        var provider=context.watch<ProfileScreenProvider>();
        return PopScope(
          canPop: true,
          child: Stack(
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
                child: Container(
                  alignment: Alignment.center,
                  width: 335.w,
                  height: 350.h,
                  
                  decoration: BoxDecoration(                    
                    color: Colors.white,                    
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(  
                    crossAxisAlignment: CrossAxisAlignment.start,                  
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 40.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r),topRight: Radius.circular(10.r)),
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back,size: 21.h,color: Colors.white,),
                        ),
                      ),                        
                      SizedBox(
                        height: 310.h,
                        width: double.infinity,
                        child: 
                        SharedPreferencesitem.getString("profileImagePath")==null
                        ?ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r)),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(
                            imageUrl: "https://drive.google.com/uc?export=download&id=1HQGGxju316dlVBAE5NkTzAa5drUkEZDm",
                            fit: BoxFit.cover,   
                                             
                          ),
                        )
                        :ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.r),bottomRight: Radius.circular(10.r)),
                          clipBehavior: Clip.antiAlias,
                          
                          child: Image.file(
                            provider.profileImage!,
                            fit: BoxFit.cover,                        
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            
            ],
          ),
        );
      }
    );
  }

