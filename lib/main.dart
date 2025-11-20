import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/theme_data.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/on%20boarding/ui/onboarding.dart';
import 'package:mindsense_app/features/sign%20up/ui/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  
      debugShowCheckedModeBanner: false,  
      theme: Themedata.darktheme,  
      home: Onboarding(),
    );
  }
}
