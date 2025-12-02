import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/features/forget%20password/logic/forgetpassword_provider.dart';
import 'package:mindsense_app/features/forget%20password/ui/widgets/forgetpassword_setemail_uppertext_wid.dart';
import 'package:provider/provider.dart';

class ForgetpasswordSetemail extends StatelessWidget {
  const ForgetpasswordSetemail({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgetpasswordProvider(),
      child: Scaffold(
      
        appBar: AppBar(),
        
        body:  GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Consumer<ForgetpasswordProvider>(
              builder: (context,val,child) {
                var provider=context.read<ForgetpasswordProvider>();
               
                return Padding(
                  padding: const EdgeInsets.only(right: 18,left: 18,top: 55),
                  child: Column(
                    children: [

                      //upper text
                      ForgetpasswordSetemailUppertext(),

                      SizedBox(height: 24.h,),

                      //form
                      Form(
                        key: provider.setEmailFormKey,
                        child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),),   
                            SizedBox(height: 5,),
                    
                            CustomTextFormField(
                              controller: provider.forgetPasswordEmailController, 
                              hintText: "Enter your email",
                              Icon: Icon(Icons.email_outlined),
                              validator:(p0) => provider.setEmailValidator(p0),
                            ),
                            
                            SizedBox(height: 32.h,),

                            // send code button
                            Center(
                              child: CustomButton(
                                text: "Send Code",
                                onPressed:() {
                                  provider.sendCodeButton(context);
                                }  
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}