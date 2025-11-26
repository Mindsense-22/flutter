import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/theme_data.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/on%20boarding/ui/onboarding_screens.dart';
import 'package:mindsense_app/features/sign%20up/ui/signup_screen.dart';
import 'package:mindsense_app/features/splash/ui/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesitem.init(); 
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) => MyApp(),
    )
  );
  
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  
      debugShowCheckedModeBanner: false,  
      theme: Themedata.darktheme,  
      home: SplashScreen(),
    );
  }
}
