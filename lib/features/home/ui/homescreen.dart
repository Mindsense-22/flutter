import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/home/ui/widgets/homescreenbuttom.dart';
import 'package:mindsense_app/features/home/ui/widgets/statusbarwidget.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
            child: Column(
              children: [
                Statusbarwidget(),
                SizedBox(height: 464.h,),
                SizedBox(height: 32.h,),
                Homescreenbuttom(),
                SizedBox(height: 16.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}