import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/exercises/logic/audio_player_provider.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/profile/ui/widgets/about_user_wid.dart';
import 'package:mindsense_app/features/profile/ui/widgets/favourite_wid.dart';
import 'package:mindsense_app/features/profile/ui/widgets/general_settings_wid.dart';
import 'package:mindsense_app/features/splash/ui/splash_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileScreenProvider>().fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final provider = context.read<Mainscreenprovider>();
        // Delay to let navigation settle
        await Future.delayed(const Duration(milliseconds: 50));
        if (!context.mounted) return;
        provider.changeIndex(0);
        log(provider.index.toString());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Profile",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 23.sp,
            ),
          ),
          leading:
          IconButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                final scm=ScaffoldMessenger.of(context);
                context.read<Mainscreenprovider>().index = 0;
                context.read<AudioProvider>().stop();
                await SharedPreferencesitem.clear();
                scm.showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      "Logged Out!",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                nav.pushAndRemoveUntil(                  
                  MaterialPageRoute(builder: (_) => SplashScreen()),
                  (route) => false,
                );                
                
              }, 
              icon: Icon(Icons.logout,
                size: 23.sp,
                color:  Colors.red,
              )
          ),
          //// Comment Setting Icon
          // actions: [          
          //   InkWell(
          //     onTap: () async{
                
          //     },
          //     borderRadius: BorderRadius.circular(120.r),            
          //     child: SvgPicture.asset(
          //       "assets/images/settings_icon_white.svg",
          //       width: 26.w,
          //       height: 26.h,
          //     ),
          //   ),
            
          //   SizedBox(width: 15.w,),            
          // ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal:  20.w),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children:  [
                AboutUserWid(),
                GeneralSettingsWid(),
                //FavouriteWid(),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

