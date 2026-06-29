import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/exercises/ui/exercises_screen.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:mindsense_app/features/home/ui/widgets/analysisrequired_wid.dart';
import 'package:provider/provider.dart';

class Exercisewid extends StatelessWidget {
  const Exercisewid({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xff1E293B), 
        borderRadius: BorderRadius.circular(20.r),        
        boxShadow: [          
          BoxShadow(            
            color: Color(0xff3DCADC).withAlpha(50),
            blurRadius: 4.r,
            offset: const Offset(2,2),
          ),
          BoxShadow(
            
            color: Color(0xff55EEDA).withAlpha(50),
            blurRadius: 4.r,
            offset: const Offset(1.5,4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          
          Text(
            "Recommended Exercises",
            style: TextStyle(                    
              color: AppColers.primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,              
            ),
          ),
          SizedBox(height: 12.h),
          Consumer<Homescreenprovider>(
            builder: (context,provider,_) {
              return SizedBox(
                height: 250.h,
                child:
                 SharedPreferencesitem.getString("currentstate_home")==null?
                 AnalysisRequiredWidget()
                 :
                 provider.showedExercises.isEmpty?
                 Center(
                  child:                  
                  CircularProgressIndicator()
                   
                 ):
                 ListView.separated(                  
                  scrollDirection: Axis.vertical,
                  itemCount:provider.showedExercises.length ,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h,),
                  itemBuilder:(context, index) =>  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          provider.showedExercises[index],
                          
                          style: TextStyle(                    
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,              
                          ),
                        ),
                      ),
                      
                    ],
                  )
                   
                ),
              );
            }
          ), 
            
        ],
      ),
    );
  
  }
}