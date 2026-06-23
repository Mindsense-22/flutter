import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/exercises/logic/audio_player_provider.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/splash/ui/splash_screen.dart';
import 'package:provider/provider.dart';

class DoctorRedirectScreen extends StatelessWidget {
  const DoctorRedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
          IconButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                final scm=ScaffoldMessenger.of(context);
                context.read<Mainscreenprovider>().index = 0;
                context.read<AudioProvider>().stop();
                await SharedPreferencesitem.clear();
                scm.showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      "Logged Out!",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                nav.pushAndRemoveUntil(                  
                  MaterialPageRoute(builder: (_) => SplashScreen()),
                  (route) => false,
                );                
                
              }, 
              icon: Icon(Icons.logout,
                size: 23.sp,
                color:  Colors.red,
              )
          ),
      ),

      body: Padding(
        padding:  EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,          
          children: [
            Text("Go to Doctor Adminestration on web ",style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),)
          ],
        ),
      ),
    );
  }
}