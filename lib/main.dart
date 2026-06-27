import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/Api/dio_factory.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/theme_data.dart';
import 'package:mindsense_app/features/Analyzing/logic/analyzing_provider.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/logic/photo_analysis_provider.dart';
import 'package:mindsense_app/features/Analyzing/report/logic/analysisreportprovider.dart';
import 'package:mindsense_app/features/Analyzing/voice%20analysis/logic/voice_analysis_provider.dart';
import 'package:mindsense_app/features/dashboard/logic/dashboard_provider.dart';
import 'package:mindsense_app/features/doctors/logic/doctors_provider.dart';
import 'package:mindsense_app/features/exercises/logic/audio_player_provider.dart';
import 'package:mindsense_app/features/exercises/logic/exercises_provider.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:mindsense_app/features/login/logic/login_provider.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:mindsense_app/features/profile/add%20contact/logic/addcontact_provider.dart';
import 'package:mindsense_app/features/profile/edit%20user%20information/logic/edit_user_information_provider.dart';
import 'package:mindsense_app/features/profile/update%20password/logic/updatepassword_provider.dart';
import 'package:mindsense_app/features/sign%20up/logic/pincode_signup_provider.dart';
import 'package:mindsense_app/features/sign%20up/logic/signup_provider.dart';
import 'package:mindsense_app/features/splash/ui/splash_screen.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/games/logic/gamification_provider.dart';
import 'package:mindsense_app/features/voice%20chat/logic/voicechat_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesitem.init(); 
  await DioFactory.init();
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
              create: (_) => PincodeSignupProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => LoginProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => Mainscreenprovider(),
            ),
            ChangeNotifierProvider(
              create: (_) => Homescreenprovider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ProfileScreenProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => PhotoAnalysisProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => VoiceAnalysisProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => Analysisreportprovider(),
            ),
            ChangeNotifierProvider(
              create: (_) => AnalyzingProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ExercisesProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => DashboardProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => AudioProvider (),
            ),
            ChangeNotifierProvider(
              create: (_) => EditUserInformationProvider (),
            ),
            ChangeNotifierProvider(
              create: (_) => GamificationProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => UpdatepasswordProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => AddcontactProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => DoctorsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => VoicechatProvider(),
            ),
          ],
        child: MyApp(),
      )
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileScreenProvider>(
      builder: (context,val,child) {
        return MaterialApp(  
          debugShowCheckedModeBanner: false,
          
          theme: val.isDarkMode ? Themedata.darktheme : Themedata.lighttheme,
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