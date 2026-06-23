import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_bottom_nav_bar.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/dashboard/ui/dashboard_screen.dart';
import 'package:mindsense_app/features/exercises/ui/exercises_screen.dart';
import 'package:mindsense_app/features/home/ui/homescreen.dart';
import 'package:mindsense_app/features/games/ui/games_hub_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/doctors/ui/doctors_screen.dart';
import 'package:mindsense_app/features/profile/ui/profile_screen.dart';
import 'package:mindsense_app/features/splash/ui/doctor_redirect_screen.dart';
import 'package:provider/provider.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const Homescreen(),
//     const DashboardScreen(),
//     const ExercisesScreen(),
//     const GamesHubScreen(),
//     const ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Mainscreenprovider>(
//       builder: (context,val,child) {
//         return Scaffold(
//           //body: _screens[val.index],
          
//           body: PageView(
//             controller: val.pageController,
//             onPageChanged: val.onPageChanged,
//             children: _screens,
//           ),

//           bottomNavigationBar: CustomBottomNavBar(
//             currentIndex: val.index,
//             onTap: (index) {
//               val.changeIndex(index);
//               // setState(() {
//               //   _currentIndex = index;
//               // });
//             },
//           ),
//         );
//       }
//     );
//   }
// }


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
    ExercisesScreen(),
    DoctorsScreen(),
    GamesHubScreen(),    
    DashboardScreen(),
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

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:mindsense_app/core/custom%20widgets/custom_bottom_nav_bar.dart';
// import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
// import 'package:mindsense_app/features/dashboard/ui/dashboard_screen.dart';
// import 'package:mindsense_app/features/doctors/ui/doctors_screen.dart';
// import 'package:mindsense_app/features/exercises/ui/exercises_screen.dart';
// import 'package:mindsense_app/features/games/ui/games_hub_screen.dart';
// import 'package:mindsense_app/features/home/ui/homescreen.dart';
// import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
// import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
// import 'package:mindsense_app/features/profile/ui/profile_screen.dart';
// import 'package:mindsense_app/features/splash/ui/doctor_redirect_screen.dart';
// import 'package:provider/provider.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   String  role="not";
  
//   @override
//   void initState() {
//     super.initState();  
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (SharedPreferencesitem.getString("token") != null) {
//         context.read<ProfileScreenProvider>().fetchUserProfile();
//       }
     
//     });
    
//   }
  

//   final List<Widget> _screens = const [
//     Homescreen(),
//     ExercisesScreen(),
//     DoctorsScreen(),
//     GamesHubScreen(),
//     DashboardScreen(),
//     ProfileScreen(),
//   ];

  

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<Mainscreenprovider>();
//     log(role);

//     return Scaffold(
//       body: role == "user"
//           ? const DoctorRedirectScreen()
//           : PageView(
//               controller: provider.pageController,
//               onPageChanged: provider.onPageChanged,
//               children: _screens,
//             ),
//       bottomNavigationBar: role == "user"
//           ? const SizedBox.shrink()
//           : CustomBottomNavBar(
//               currentIndex: provider.index,
//               onTap: provider.changeIndex,
//             ),
//     );
//   }
// }
