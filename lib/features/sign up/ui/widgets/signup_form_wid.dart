import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/features/sign%20up/logic/signup_provider.dart';

class SignupFormWid extends StatelessWidget {
  const SignupFormWid({super.key, required this.provider});
  final SignupProvider provider;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: provider.formKey,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          Text("Name",style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),   
          SizedBox(height: 4,),

          CustomTextFormField(
            controller: provider.signupNameController, 
            hintText: "Enter your Name",
            Icon: Icon(Icons.person_2_outlined),
            validator: provider.nameValidator,
            
          ),
          SizedBox(height: 16,),
    
    
          Text("Email",style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),   
          SizedBox(height: 4,),

          CustomTextFormField(
            controller: provider.signupEmailController, 
            hintText: "Enter your email",
            Icon: Icon(Icons.email_outlined),
            validator: provider.emailValidator,                                
          ),
          SizedBox(height: 16,),

          Text("Password",style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSecondary,
          ),),
    
          SizedBox(height: 4,),
    
          CustomPasswordTextFormField(
            controller: provider.signupPasswordController, 
            hintText: "password",
            validator: provider.passwordValidator,
          ),              
          
          
          SizedBox(height: 32,),
          //login button
          Center(
            child: CustomButton(text:"Sign Up",
            onPressed: () {
              provider.signupButton();
            },
            ),
          ),
        ],

      ),
    );
  }
}