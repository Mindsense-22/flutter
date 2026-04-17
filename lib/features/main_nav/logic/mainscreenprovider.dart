// import 'package:flutter/material.dart';

// class Mainscreenprovider extends ChangeNotifier{
//   int index=0;
  
//   void changeIndex(index){
//     this.index=index;
//     notifyListeners();
//   }
// }

// import 'package:flutter/material.dart';

// class Mainscreenprovider extends ChangeNotifier {
//   int index = 0;

//   final PageController pageController = PageController();

//   void changeIndex(int newIndex) {
//     index = newIndex;

//     pageController.animateToPage(
//       newIndex,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );

//     notifyListeners();
//   }

//   void onPageChanged(int newIndex) {
//     index = newIndex;
//     notifyListeners();
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';

class Mainscreenprovider extends ChangeNotifier {
  int index = 0;

  final PageController pageController = PageController();

  // void changeIndex(int newIndex) {
  //   index = newIndex;

  //   pageController.animateToPage(
  //     newIndex,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  //   log(index.toString());
  //   notifyListeners();
  // }
  void changeIndex(int newIndex) {
    index = newIndex;
    notifyListeners();

    if (pageController.hasClients) {
      pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceIn,
      );
    }

    log(index.toString());
  }

  void onPageChanged(int newIndex) {
    index = newIndex; 
    log(index.toString());   
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}