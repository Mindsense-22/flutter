import 'package:flutter/material.dart';

class Mainscreenprovider extends ChangeNotifier{
  int index=0;
  
  void changeIndex(index){
    this.index=index;
    notifyListeners();
  }
}