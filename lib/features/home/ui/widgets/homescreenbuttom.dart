import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/Analyzing/chossen_screen.dart';
import 'package:mindsense_app/features/Analyzing/photo%20analysis/ui/start_photo_scan_screen.dart';
import 'package:mindsense_app/features/main_nav/logic/mainscreenprovider.dart';
import 'package:provider/provider.dart';

class Homescreenbuttom extends StatelessWidget {
  const Homescreenbuttom({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Start now to understand your feelings better", style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp
          ),
        ),
        SizedBox(height: 16.h,),
        Container(
          
          width: double.infinity,  
          height: 51.h,     
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColers.primaryColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Consumer<Mainscreenprovider>(
            builder: (context,val,child) {
              return MaterialButton(
                padding: EdgeInsets.all(8),
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChossenScreen(),));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Start Analysis  ",style: TextStyle(
                      
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),),
                    Icon(
                      Icons.arrow_forward_sharp,
                      size: 22.sp,
                      color: Colors.black,
                    ),
                  ],
                ),                    
              );
            }
          ),
        )
      ],
    );
  }
}