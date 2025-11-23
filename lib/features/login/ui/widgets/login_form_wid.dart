import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/features/login/logic/login_provider.dart';

class LoginFormWid extends StatelessWidget {
  const LoginFormWid({super.key, required this.provider});
  final LoginProvider provider;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: provider.formKey,
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
              controller: provider.loginEmailController, 
              hintText: "Enter your email",
              Icon: Icon(Icons.email_outlined),
              validator: provider.emailValidator,
            ),

            SizedBox(height: 16,),

            Text("Password",style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),),
        
            SizedBox(height: 5,),
        
            CustomPasswordTextFormField(
              controller: provider.loginpasswordController, 
              hintText: "password",
              validator: provider.passwordValidator
            ),              
            // forgot password
            Container(
              alignment: Alignment.bottomRight ,
              child: TextButton(                    
                onPressed: (){},
                child: Text("Forgot Password?",                      
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
              ),)),
            ),
            
            SizedBox(height: 28,),
            //login button
            Center(
              child: CustomButton(
                text: "Login",
                onPressed:() {
                  provider.loginButton(context);                                  
                }  
              ),
            ),
          ],

        ),
    );
  }
}