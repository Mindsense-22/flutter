import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:mindsense_app/features/on%20boarding/ui/onboarding_screens.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/splash/ui/doctor_redirect_screen.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   
    log("token :${SharedPreferencesitem.getString("token").toString()}");
    Future.delayed(Duration(milliseconds: 1400)).then((value) {
      
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) =>
         SharedPreferencesitem.getString("token")==null? OnboardingScreens():MainScreen(),       
         
        ), 
        (route) => false,        
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 175.w,
                    height: 175.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      //color: Colors.blue, 
                      border: Border.all(
                        color:  Color(0xff55EEDA).withValues(alpha: .2),
                        width: 1.5,         
                      ),
                      borderRadius: BorderRadius.circular(100), 
                    ),
                  ),
                  Positioned(
                    top:-33,
                    bottom: -23,
                    child: Image.asset(
                      "assets/images/logo2.png",
                      width: 137.9.w,
                      height: 143.7.h,
                    ),
                  ),
                  Container(
                    width: 129.9.w,
                    height: 129.9.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,                        
                      border: Border.all(
                        color:  Color(0xff55EEDA).withValues(alpha: .2),
                        width: 1.5,         
                      ),
                      borderRadius: BorderRadius.circular(200), 
                    ),
                  ),
                  Positioned(
                   
                    bottom: 120,
                    child: Image.asset(
                      "assets/images/arrows.png",
                      width: 80.w,
                      height: 36.h,
                    ),
                  ),
                  
                  
              
                ],
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Mind",style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,                
                  ),),
                  Text("Sense",style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold, 
                    color: Theme.of(context).colorScheme.primary              
                  ),)
                ],
              )
              
            ],
          ),
        ),
      ),      
    );
  }
}