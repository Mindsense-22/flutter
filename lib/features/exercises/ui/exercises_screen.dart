import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/exercises/logic/exercises_provider.dart';
import 'package:mindsense_app/features/exercises/ui/widgets/ai_recomendation_wid.dart';
import 'package:provider/provider.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(


      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Exercises",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22.sp,
              color: Theme.of(context).colorScheme.onSecondary
            ),
          ),
          centerTitle: true,
        ),
      
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding:EdgeInsets.only(left: 12.w),
            child: Consumer<ExercisesProvider>(
              builder: (context,val,child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                    
                    AiRecommendationCard(aiRecomendationSession: val.aiRecomendationSession,),
                    SizedBox(height: 24.h,),

                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}