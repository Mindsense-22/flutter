import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/theme_data.dart';
import 'package:mindsense_app/features/login/logic/login_provider.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/on%20boarding/ui/onboarding_screens.dart';
import 'package:mindsense_app/features/sign%20up/logic/signup_provider.dart';
import 'package:mindsense_app/features/sign%20up/ui/signup_screen.dart';
import 'package:mindsense_app/features/splash/ui/splash_screen.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesitem.init(); 
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) =>
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => SignupProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => LoginProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => Mainscreenprovider(),
            ),
          ],
        child: MyApp(),
      )
    )
  );
  
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(// change it with dark mode provider
      builder: (context,val,child) {
        return MaterialApp(  
          debugShowCheckedModeBanner: false,  
          theme:Themedata.darktheme, 
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
          home: SplashScreen(),
        );
      }
    );
  }
}

  