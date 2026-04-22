import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/drive%20mode/ui/drivemode_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';

class Statusbarwidget extends StatelessWidget {
  const Statusbarwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileScreenProvider>(
      builder: (context,val,child) {
        return Row(
          children: [
            
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
                splashColor: const Color.fromARGB(255, 85, 85, 85),
                onTap: () {
                  context.read<Mainscreenprovider>().changeIndex(3);
                },
                child: Ink(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColers.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(48.r)),
                  ),
                  child: 
                  SharedPreferencesitem.getString("profileImagePath")==null
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
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.r),
                splashColor: Colors.blue,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DrivemodeScreen(),));
                },
                child: Ink(
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
            ),
          ],
        );
      }
    );
  }
}