
import 'dart:developer';

import 'package:flutter/material.dart';

class Mainscreenprovider extends ChangeNotifier {
  int index = 0;

  PageController pageController = PageController();

  void jumpToIndex(int newIndex) {
    index = newIndex;
    pageController = PageController(initialPage: newIndex);
    notifyListeners();
  }


  void changeIndex(int newIndex) {
    index = newIndex;
    notifyListeners();

    if (pageController.hasClients) {
      pageController.animateToPage(
        newIndex,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );
    }

    log(index.toString());
  }

  void onPageChanged(int newIndex) {
    index = newIndex; 
    //log(index.toString());   
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}