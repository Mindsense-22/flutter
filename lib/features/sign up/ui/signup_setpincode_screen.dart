import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/features/forget%20password/ui/widgets/forgetpassword_setpincode_uppertext_wid.dart';
import 'package:mindsense_app/features/sign%20up/logic/pincode_signup_provider.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/signup_pincodetextfield_wid.dart';
import 'package:provider/provider.dart';

class SignupSetpincodeScreen extends StatelessWidget {
  const SignupSetpincodeScreen({super.key, required this.context});
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PincodeSignupProvider(),
      child: Scaffold(
        appBar: AppBar(),

        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Consumer<PincodeSignupProvider>(
              builder: (context,val,child) {
                var provider=context.read<PincodeSignupProvider>();
                return Padding(
                  padding: const EdgeInsets.only(right: 18,left: 18,top: 56),
                  child: Column(
                    
                    children: [

                      ForgetpasswordSetpincodeUppertextWid(),

                      SizedBox(height: 48.h,),

                      //form
                      Form(
                        key: provider.setPinCodeFormKey,
                        child: 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SignupPincodetextfieldWid(provider: provider,),
                            
                            SizedBox(height: 32.h,),
                            Consumer<PincodeSignupProvider>(
                              builder: (context,val,child) {
                                return Column(
                                  children: [
                                    val.verifyCodeButtonisloading==false?
                                    Center(
                                      child: CustomButton(
                                        text: "Verify",
                                        onPressed:() {
                                          provider.checkSignUpPinCode(this.context);                                  
                                        }  
                                      ),
                                    ):
                                    Center(
                                      child: CircularProgressIndicator()
                                    ),
                                  ],
                                );
                              }
                            )
                            
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h,),
                      provider.isresendcode==false?
                      Container(
                        alignment: Alignment.bottomRight ,
                        child: TextButton(
                          onPressed:() {
                            provider.resendCode(context);
                          }, 
                          child:
                          
                          Text(
                            "Resend Code?",
                            textAlign: TextAlign.end,
                            style: TextStyle(                              
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                            ),
                          ),
                        ),
                      ):Column(
                        children: [
                          SizedBox(height: 20.h,),
                          Container(
                            alignment: Alignment.bottomRight ,
                            width: 30.w,
                            height: 30.h,
                            child: CircularProgressIndicator()),
                        ],
                      )
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



