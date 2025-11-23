import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';
import 'package:mindsense_app/features/on%20boarding/data/onboarding_model.dart';


class OnboardingPageWed extends StatelessWidget {
   final OnboardingModel modeldata;
   OnboardingPageWed({super.key ,required this.modeldata});
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Stack(
              children: [
                //1
                Image.asset(modeldata.imageurl ,
                  width: double.infinity,
                  height: 600,
                  fit: BoxFit.cover,
                ),
                //2
                Positioned(
                  right: 10,
                  bottom: 450,
                  child: Opacity(
                    opacity: .90,
                    child: Container(
                      height: 35,
                      width: 65,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xffE8E9EC),
                        borderRadius: BorderRadius.circular(20), 
                                             
                      ),
                      child: MaterialButton(
                        onPressed: (){
                          Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => LoginScreen(),),                          
                          );
                        },
                        child: Text("skip",style: TextStyle(
                          color: Color(0xff121A32),
                          fontWeight: FontWeight.w500
                          
                          
                          
                        ),),                    
                      ),
                    ),
                  ),
                ),                        
              ],
            ),

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
                      modeldata.text1,style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,  
                    ),),
                    SizedBox(height: 20,),
                    Text(
                      textAlign: TextAlign.center,
                      modeldata.text2,style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: TextColers.secondaryTextColor 
                    ),),              
                    SizedBox(height: 10,),    
                  ],
                ),
              ),
            ),
          ],
        );
      }
}