import 'package:flutter/material.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/on%20boarding/ui/onboarding_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();    
    Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreens(),), 
        (route) => false,        
      );
    },);
  }

  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/images/onp1.jpg",
        height: 200,
        width: 200,    
      )
    );
  }

}