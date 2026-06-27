import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_bottom_nav_bar.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/community/ui/community_screen.dart';
import 'package:mindsense_app/features/home/ui/homescreen.dart';
import 'package:mindsense_app/features/games/ui/games_hub_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/doctors/ui/doctors_screen.dart';
import 'package:mindsense_app/features/profile/ui/profile_screen.dart';
import 'package:mindsense_app/features/splash/ui/doctor_redirect_screen.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/features/voice%20chat/ui/voicechat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (SharedPreferencesitem.getString("token") != null) {
        context.read<ProfileScreenProvider>().fetchUserProfile();
      }
    });
    
  }
  final List<Widget> _screens = const [
    Homescreen(),
    VoicechatScreen(),
    DoctorsScreen(),
    GamesHubScreen(canpop: false,),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Mainscreenprovider>();
    
    return Scaffold(
      body:
       SharedPreferencesitem.getString("userRole")=="professional"?DoctorRedirectScreen():
       PageView(        
        physics: const PageScrollPhysics(),
        controller: provider.pageController,
        onPageChanged: provider.onPageChanged,
        children: _screens,
      ),

      bottomNavigationBar:
      SharedPreferencesitem.getString("userRole")=="professional"?
      SizedBox.shrink():
       CustomBottomNavBar(
        currentIndex: provider.index,
        onTap: provider.changeIndex,
      ),
    );
  }
}