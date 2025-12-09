import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class Themedata {

  // static final lighttheme=ThemeData(    
  //   colorScheme:const ColorScheme.light(
  //     primary: LightThemeColors.primaryColor,
  //     secondary: LightThemeColors.secondaryColor,
  //     error: Colors.red,
  //     onPrimary: Colors.black,
  //     onSecondary: Colors.black
  //   ),
  //   scaffoldBackgroundColor: LightThemeColors.backgroundColor,
  //   appBarTheme:const AppBarTheme(
  //     titleTextStyle: TextStyle(
  //       fontSize: 30,
  //       fontWeight: FontWeight.bold,
  //       color: Colors.white,            
  //     ),
  //     color: LightThemeColors.primaryColor,
  //     iconTheme: IconThemeData(
  //       color: Colors.white,
  //       size: 32
  //     ),          
  //   ),
    
  //   floatingActionButtonTheme:const FloatingActionButtonThemeData(
  //     backgroundColor: LightThemeColors.primaryColor,
  //     iconSize: 30,          
  //   ),
  //   //fontFamily: "Montserrat",
  // );



  static final darktheme=ThemeData(    
    
    colorScheme:const ColorScheme.dark(
      primary: DarkThemeColors.primaryColor,
      secondary: DarkThemeColors.secondaryColor,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white
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