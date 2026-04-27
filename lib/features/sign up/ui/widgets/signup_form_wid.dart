import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_ageformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_emailtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/features/sign%20up/logic/signup_provider.dart';
import 'package:provider/provider.dart';

class SignupFormWid extends StatelessWidget {
  const SignupFormWid({super.key, required this.provider, required this.context});
  final SignupProvider provider;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: provider.formKey,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          Text("Name",style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),   
          SizedBox(height: 4.h,),

          CustomTextFormField(
            controller: provider.signupNameController, 
            hintText: "Enter your Name",
            //Icon: Icon(Icons.person_2_outlined),
            Icon: Padding(
              padding: const EdgeInsets.all(11.0),
              child: SvgPicture.asset(
                "assets/images/user-icon.svg",
                width: 21.5.w,
                height: 18.5.h,
              ),
            ),
            validator: provider.nameValidator,
            
          ),
          SizedBox(height: 14.h,),
          Text("Age",style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),   
          SizedBox(height: 4.h,),

          CustomAgeformfield(
            controller: provider.signupAgeController, 
            hintText: "Enter your age",
            icon: Icon(Icons.email_outlined),
            validator: provider.ageValidator,                                
          ),
          SizedBox(height: 14.h,),
    
    
          Text("Email",style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),   
          SizedBox(height: 4.h,),

          CustomEmailTextFormField(
            controller: provider.signupEmailController, 
            hintText: "Enter your email",
            icon: Icon(Icons.email_outlined),
            validator: provider.emailValidator,                                
          ),
          SizedBox(height: 14.h,),

          

          Text("Password",style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),
    
          SizedBox(height: 4.h,),
    
          CustomPasswordTextFormField(
            controller: provider.signupPasswordController, 
            hintText: "password",
            validator: provider.passwordValidator,
          ),          
          SizedBox(height: 14.h),
          Text("Re Enetr Password",style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),
    
          SizedBox(height: 4.h,),
    
          CustomPasswordTextFormField(
            controller: provider.signupReEnterPasswordController, 
            hintText: "re enter password",
            validator: provider.reEnterpasswordValidator,
          ),    
          
          
          SizedBox(height: 25.h,),
          //login button
          Consumer<SignupProvider>(
            builder: (context,val,child) {
              return Column(
                children: [
                  val.signupbuttonisloading==false?
                  Center(
                    child: CustomButton(text:"Sign Up",
                    onPressed: () {
                      provider.signupButton(this.context);
                    },
                    ),
                  ):
                  Center(child: CircularProgressIndicator())
                ],
              );
            }
          )
          
        ],

      ),
    );
  }


}