import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/login/ui/login_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  TextEditingController signupPasswordController=TextEditingController();
  TextEditingController signupNameController=TextEditingController();
  TextEditingController signupEmailController=TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),

      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 10,left: 10,top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,        
              children: [
            
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome to",style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),),
                    Text("Smart Emotion",style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: TextColers.thirdTextColor,
                      
                    ),),
                  ],
                ),
                SizedBox(height: 10,),
                Text("Sign in to your account",style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),),
                SizedBox(height: 25,),
                
                //form
                Form(
                  key: formKey,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("Name",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),),   
                        SizedBox(height: 5,),
            
                        CustomTextFormField(
                          controller: signupNameController, 
                          hintText: "Enter your Name",
                          Icon: Icon(Icons.person_2_outlined),
                          
                        ),
                        SizedBox(height: 15,),


                        Text("Email",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),),   
                        SizedBox(height: 5,),
            
                        CustomTextFormField(
                          controller: signupEmailController, 
                          hintText: "Enter your email",
                          Icon: Icon(Icons.email_outlined),
                          
                        ),
                        SizedBox(height: 15,),
            
                        Text("Password",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),),

                        SizedBox(height: 5,),

                        CustomPasswordTextFormField(
                          controller: signupPasswordController, 
                          hintText: "password",
                        ),              
                        
                        
                        SizedBox(height: 35,),
                        //login button
                        CustomButton(text:"Sign Up"),
                      ],
            
                    ),
                ),
          
                SizedBox(height: 35,),
          
                Text("or continue with",style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),),

                SizedBox(height: 30,),
          
                //platforms images
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 50,
                  children: [
                    InkWell(
                      onTap: () {
                        
                      },
                      child: Image.asset("assets/images/google.png"),
                    ),
          
                    InkWell(
                      onTap: () {
                        
                      },
                      child: Image.asset("assets/images/apple.png"),
                    ),
          
                    InkWell(
                      onTap: () {
                        
                      },
                      child: Image.asset("assets/images/facebook.png"),
                    ),
                    
                  ],
                ),
          
                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" Don you have an account?",style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),),
                    TextButton(                    
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                          (route) => false,   
                        );
                      },
                      child: Text("Log In",                      
                        style: TextStyle(
                          fontSize: 20,
                      fontWeight: FontWeight.w500,
                          color: TextColers.thirdTextColor
                    ),)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}