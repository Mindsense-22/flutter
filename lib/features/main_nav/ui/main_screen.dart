import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_bottom_nav_bar.dart';
import 'package:mindsense_app/features/home/ui/homescreen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:mindsense_app/features/profile/ui/profile_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Homescreen(),
    const Center(child: Text("Statistics Screen", style: TextStyle(color: Colors.white, fontSize: 24))),
    const Center(child: Text("Apps Screen", style: TextStyle(color: Colors.white, fontSize: 24))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<Mainscreenprovider>(
      builder: (context,val,child) {
        return Scaffold(
          body: _screens[val.index],
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: val.index,
            onTap: (index) {
              val.changeIndex(index);
              // setState(() {
              //   _currentIndex = index;
              // });
            },
          ),
        );
      }
    );
  }
}
