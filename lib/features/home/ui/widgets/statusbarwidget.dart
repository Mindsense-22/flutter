import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/Api/api_constants.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/drive%20mode/ui/drivemode_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statusbarwidget extends StatefulWidget {
  const Statusbarwidget({super.key});

  @override
  State<Statusbarwidget> createState() => _StatusbarwidgetState();
}

class _StatusbarwidgetState extends State<Statusbarwidget> {
   @override
  void initState() {
    super.initState();
  }
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
                  context.read<Mainscreenprovider>().changeIndex(6);
                },
                child: Ink(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(48.r)),
                  ),
                  child: 
                  val.avatarLink == null || val.avatarLink!.isEmpty
                  ?Container(
                    clipBehavior: Clip.antiAlias,                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(108.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: "https://drive.google.com/uc?export=download&id=1HQGGxju316dlVBAE5NkTzAa5drUkEZDm",
                      fit: BoxFit.fill,                    
                    ),
                  )
                  :Container(
                    clipBehavior: Clip.antiAlias,                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(108.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl:ApiConstants.baseUrl + val.avatarLink!,
                      fit: BoxFit.fill,                    
                    ),
                  )
                  
                ),
              ),
            ),            
            SizedBox(width: 8.w,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Hello, ",style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff7C9CD1)
                      ),
                    ),
                    Text(
                     (SharedPreferencesitem.getString("userName") ?? val.userName ?? "")
                        .split(" ")
                        .first,style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff7C9CD1)
                      ),
                    ),
                  ],
                ),
                SizedBox(height:  2.h),
                Text(
                  "Here is your Emotional \nwellness overview",style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
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