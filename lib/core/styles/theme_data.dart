import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class Themedata {

  static final lighttheme=ThemeData(    
    colorScheme:const ColorScheme.dark(
      primary: DarkThemeColors.primaryColor,
      secondary:Color(0xffE8E9EC) ,      
      error: Colors.red,
      onPrimary:DarkThemeColors.onSecondaryColor,
      onSecondary: DarkThemeColors.onprimaryColor
    ),
    iconTheme: const IconThemeData(
      color: Colors.white
    ),
    
    scaffoldBackgroundColor: Colors.white,
    appBarTheme:const AppBarTheme(
      // this two lines to make appbar not change its color
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,            
      ),
      color: Colors.white,
                
    ),
    floatingActionButtonTheme:const FloatingActionButtonThemeData(
      backgroundColor: DarkThemeColors.primaryColor,
      iconSize: 30,          
    ),
    fontFamily: "inter",
  );



  static final darktheme=ThemeData(    
    
    colorScheme:const ColorScheme.dark(
      primary: DarkThemeColors.primaryColor,
      secondary:Color(0xffE8E9EC) ,      
      error: Colors.red,
      onPrimary:DarkThemeColors.onprimaryColor,
      onSecondary: DarkThemeColors.onSecondaryColor
    ),
    iconTheme: const IconThemeData(
      color: Colors.white
    ),
    
    scaffoldBackgroundColor: DarkThemeColors.backgroundColor,
    appBarTheme:const AppBarTheme(
      // this two lines to make appbar not change its color
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      
      titleTextStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,            
      ),
      color: DarkThemeColors.backgroundColor,
                
    ),
    floatingActionButtonTheme:const FloatingActionButtonThemeData(
      backgroundColor: DarkThemeColors.primaryColor,
      iconSize: 30,          
    ),
    fontFamily: "inter",

  );

}