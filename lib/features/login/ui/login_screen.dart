import 'package:flutter/material.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/login/logic/login_provider.dart';
import 'package:mindsense_app/features/sign%20up/ui/signup_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {  
   LoginScreen({super.key});
    
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
              padding: const EdgeInsets.only(right: 10,left: 10,top: 45),
              child: Consumer<LoginProvider>(
                builder: (context,val,child) {
                  var provider=context.read<LoginProvider>();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,        
                    children: [
                  
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Welcome",style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),),
                          Text("back!",style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: TextColers.thirdTextColor,
                            
                          ),),
                        ],
                      ),

                      SizedBox(height: 10,),

                      Text("Login to your account",style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),),

                      SizedBox(height: 25,),
                      
                      //form
                      Form(
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

                              SizedBox(height: 15,),
                  
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
                              
                              SizedBox(height: 15,),
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
                          Text(" Don't you have an account?",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),),
                          TextButton(                    
                            onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context) => SignupScreen(),));
                            },
                            child: Text("Sign Up",                      
                              style: TextStyle(
                                fontSize: 20,
                            fontWeight: FontWeight.w500,
                                color: TextColers.thirdTextColor
                          ),)),
                        ],
                      )
                  
                  
                      
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