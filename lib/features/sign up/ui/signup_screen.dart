import 'package:flutter/material.dart';
import 'package:mindsense_app/features/sign%20up/logic/signup_provider.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/signup_form_wid.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/signup_platforms_auth_wid.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/signup_uppertext_wid.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/tologin_widget.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupProvider(),
      child: Scaffold(
      
        appBar: AppBar(),
      
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 18,left: 18,top: 50),
              child: Consumer(
                builder: (context,val,child) {
                  var provider=context.read<SignupProvider>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,        
                    children: [
                      // upper text wid
                      SignupUppertextWid(),

                      SizedBox(height: 48,),
                      
                      //signup form widget
                      SignupFormWid(provider: provider,),
                              
                      SizedBox(height: 24,),
                              
                      Text("or continue with",style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),),
                        
                      SizedBox(height: 24,),
                              
                      //platforms auth widget
                      SignupPlatformsAuthWid(),
                     
                      SizedBox(height: 24,),
                      
                      //to login widget  
                      TologinWidget(),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}