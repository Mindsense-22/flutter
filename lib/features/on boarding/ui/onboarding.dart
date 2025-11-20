import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentPage=0;
  int index=0;
  List onBoardingItems=[
    {"image":"assets/images/onp1.png","text1":"Your System for Instant Self\n Awareness","text2":"Analyze your emotional state, and get the perfect\n mindful recommendation before stress escalates."},
    {"image":"","text1":"Your Instant Emotional Awareness\n System","text2":"Smart AI that instantly detects your mood and\n guides you toward calm, clarity, and balance"},
    {"image":"","text1":"Know your mood and make your day\n better","text2":"Get an instant insight into your mood, with simple\n tips to help you calm down and feel better."}
  ];
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Column(
        children: [

          Stack(
            children: [
              //1
              Image.asset("assets/images/onp1.jpg" ,
                width: double.infinity,
                height: 560,
                fit: BoxFit.cover,
              ),
              //2
              Positioned(
                right: 10,
                bottom: 450,
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Color(0xffE8E9EC),
                    borderRadius: BorderRadius.circular(20),
                    
                  ),
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.pushAndRemoveUntil(context, 
                        MaterialPageRoute(builder: (context) => LoginScreen(),), 
                        (route) => false,
                      );
                    },
                    child: Text("skip",style: TextStyle(
                      color: Colors.black,
                    ),),
                  
                  ),
                ),
              ),
                      
            ],
          ),
          //3
          Transform.translate(
            offset: Offset(0, -5),
            child: Container(
              padding: EdgeInsets.all(10),              
              width: double.infinity,             
              decoration: BoxDecoration(
                color: AppColers.backgroundColor,              
                borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(15),
                 topRight: Radius.circular(15),
                 
                ),
                border: const Border(
                  top: BorderSide(color: AppColers.primaryColor, width: 1.5),
                ),
            
              ),
              child: Column(
                spacing: 2,
                mainAxisAlignment: MainAxisAlignment.center,
            
                children: [
                  SizedBox(height: 20,),
                  Text(
                    textAlign: TextAlign.center,                  
                    "Your System for Instant Self\n Awareness",style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    
                  ),),
                  SizedBox(height: 20,),
                  Text(
                    textAlign: TextAlign.center,
                    "Analyze your emotional state, and get the perfect\n mindful recommendation before stress escalates.",style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),),
            
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: 120,
                    color: Colors.white,
                  )
                  
                ],
              ),
            ),
          ),

          SizedBox(height: 20,),

          Padding(
            padding: const EdgeInsets.all(6),
            child: CustomButton(text: "Next",onpreessed: (p0) {
              setState(() {
                index++;
                if(index>2){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => LoginScreen(),), 
                    
                  );
                }
              });
            },),
          )

         
    
    
          
        ],
      )
    ); 
  }
}
