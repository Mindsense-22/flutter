import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/features/forget%20password/logic/forgetpassword_provider.dart';
import 'package:mindsense_app/features/forget%20password/ui/widgets/forgetpasswoed_setnewpassword_uppertext_wid.dart';

import 'package:provider/provider.dart';

class ForgetpasswoedSetnewpassword extends StatelessWidget {
  const ForgetpasswoedSetnewpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgetpasswordProvider(),
      child: Scaffold(
        appBar: AppBar(),
        
        body:GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 18,left: 18,top: 16),
              child: Consumer<ForgetpasswordProvider>(

                builder: (context,val,child) {
                  var provider=context.read<ForgetpasswordProvider>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ForgetpasswoedSetnewpasswordUppertextWid(),
                      SizedBox(height: 48,),
                      Form(
                        key: provider.setNewPasswoedFormKey,
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("New Password",style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),),   
                              SizedBox(height: 4,),
                      
                              CustomPasswordTextFormField(
                                controller: provider.setNewPasswoedController, 
                                hintText: "password",
                                validator: provider.passwordValidator
                              ),

                              SizedBox(height: 16,),
                      
                              Text("Confirm Password",style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),),
                          
                              SizedBox(height: 5,),
                          
                              CustomPasswordTextFormField(
                                controller: provider.confirmPasswoedController, 
                                hintText: "Confirm Password",
                                validator: provider.confirmPasswordValidator
                              ),              
                                                  
                              SizedBox(height: 32,),
                              // button
                              Center(
                                child: CustomButton(
                                  text: "Reset Password",
                                  onPressed:() {
                                    provider.resetPasswordButton(context);
                                    provider.passwordChangeSuccessfuly?provider.messgeShowDialog(context):log("dialog not show");                                  
                                  }  
                                ),
                              ),
                            ],
                      
                          ),
                      ),
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