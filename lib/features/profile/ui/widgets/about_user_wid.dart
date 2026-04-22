import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

class AboutUserWid extends StatelessWidget {
  const AboutUserWid({super.key});

  @override
  Widget build(BuildContext context) { 
      
    return Consumer<ProfileScreenProvider>(      
      builder: (context,val,child) {
        return Column(
          children: [
            SizedBox(height: 18.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    color: Color(0xff2DD4BF).withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(108.r),
                    border: Border.all(
                      color: AppColers.primaryColor.withValues(alpha: .3),
                      width: 2.w,
                    ),                
                  ),              
                ),
                Positioned(
                  top: 7,
                  child: Container(
                    width: 98.w,
                    height: 98.w,
                    decoration: BoxDecoration(                
                    borderRadius: BorderRadius.circular(108.r),                                
                  ),
                    child:
                      val.profileImagePath==null
                      ?CachedNetworkImage(
                        imageUrl: "https://drive.google.com/uc?export=download&id=1HQGGxju316dlVBAE5NkTzAa5drUkEZDm",
                        fit: BoxFit.fill,                    
                      )
                      :ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(108.r),
                        child: Image.file(
                          context.watch<ProfileScreenProvider>().profileImage!,
                          fit: BoxFit.cover,                        
                        ),
                      ),
                  ),            
                ),
                
                Positioned(
                  bottom: 1.w,
                  right: 1.w,
                  child: InkWell(
                    onTap: () {
                      val.pickGalleryImage();
                    },
                    borderRadius: BorderRadius.circular(150.r),
                    splashColor: Colors.grey,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColers.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xff0B0F19),
                          width: 2.w,
                        ), 
                        // boxShadow: [          
                        //   BoxShadow(            
                        //     color: Color(0xff2DD4BF).withAlpha(40),
                        //     blurRadius: 16.r,
                        //     offset: const Offset(0,-10),
                        //   ),
                        //   BoxShadow(
                            
                        //     color: Color(0xff2DD4BF).withAlpha(40),
                        //     blurRadius: 16.r,
                        //     offset: const Offset(2,10),
                        //   ),
                        // ],
                      ),
                      child: SvgPicture.asset("assets/images/camera_icon_black.svg",
                        height: 16.h,
                        width: 16.w,
                      )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Username",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              SharedPreferencesitem.getString("gmail")??              
              "Example@gmail.com",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: .7),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        );
      }
    );
  }
}

