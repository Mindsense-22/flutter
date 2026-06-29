import 'dart:developer';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/on%20boarding/data/onboarding_model.dart';

class OnboardingProvider extends ChangeNotifier{
  int currentPage=0;  
  int position=0;
  final carouselController = CarouselSliderController();
  List <OnboardingModel> onboardingdata=[
    OnboardingModel(imageurl: "assets/images/onp1.png", text1: "Your System for Instant Self\n Awareness", text2: "Analyze your emotional state, and get the perfect\n mindful recommendation before stress escalates."),
    OnboardingModel(imageurl: "assets/images/onp2.jpg", text1: "Your Instant Emotional Awareness\n System", text2: "Smart AI that instantly detects your mood and\n guides you toward calm, clarity, and balance"),
    OnboardingModel(imageurl: "assets/images/onp3.jpg", text1: "Know your mood and make your day\n better", text2: "Get an instant insight into your mood, with simple\n tips to help you calm down and feel better.")
  ];

  /// Increment the page or navigate to login if last page
  void checkFinalPage(BuildContext context) {
    if (position+1 > 2) {     
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
      currentPage==0;
      notifyListeners();
      log(currentPage.toString());
    }
  }

  void updateCurrentpage(int index){
    currentPage=index;
    position=currentPage;
    log(currentPage.toString());
    notifyListeners();
  }

  void resetProvider() {
    currentPage = 0;
    position = 0;
    notifyListeners();
  }
}