import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_bottom_nav_bar.dart';
import 'package:mindsense_app/features/dashboard/ui/dashboard_screen.dart';
import 'package:mindsense_app/features/exercises/ui/exercises_screen.dart';
import 'package:mindsense_app/features/home/ui/homescreen.dart';
import 'package:mindsense_app/features/games/ui/games_hub_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/doctors/ui/doctors_screen.dart';
import 'package:mindsense_app/features/profile/ui/profile_screen.dart';
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


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _screens = const [
    Homescreen(),
    DashboardScreen(),
    ExercisesScreen(),
    GamesHubScreen(),
    DoctorsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Mainscreenprovider>();
    
    return Scaffold(
      body: PageView(        
        physics: const PageScrollPhysics(),
        controller: provider.pageController,
        onPageChanged: provider.onPageChanged,
        children: _screens,
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: provider.index,
        onTap: provider.changeIndex,
      ),
    );
  }
}
