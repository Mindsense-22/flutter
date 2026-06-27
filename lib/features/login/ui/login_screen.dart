import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/features/login/logic/login_provider.dart';
import 'package:mindsense_app/features/login/ui/widgets/login_form_wid.dart';
import 'package:mindsense_app/features/login/ui/widgets/tosignup_wid.dart';
import 'package:mindsense_app/features/login/ui/widgets/uppertext_wid.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {  
  const LoginScreen({super.key});    
  @override
  Widget build(BuildContext context) {    
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: Scaffold(

        appBar: AppBar(),
      
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 18,left: 18,top: 55),
              child: Consumer<LoginProvider>(
                builder: (context,val,child) {
                  var provider=context.read<LoginProvider>();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,      
                    children: [                  
                      //upper text widget
                      UppertextWid(),

                      SizedBox(height: 24.h,),

                      //login form                      
                      LoginFormWid( provider: provider,),
                              
                      SizedBox(height: 24,),                 
                          
                      SizedBox(height: 24,),
                      
                      SizedBox(height: 24,),
                          
                      //to sign up page
                      Center(child: TosignupWid()),

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