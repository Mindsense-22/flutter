import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
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
                if (!context.mounted) return;
                customSnackbar(context,true,"Loged Out");
                context.read<Mainscreenprovider>().index = 0;
                context.read<AudioProvider>().stop();
                await SharedPreferencesitem.clear();
                
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushAndRemoveUntil(                  
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