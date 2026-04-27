import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/profile/edit%20user%20information/logic/edit_user_information_provider.dart';
import 'package:mindsense_app/features/profile/update%20password/logic/updatepassword_provider.dart';
import 'package:provider/provider.dart';

class UpdatepasswordScreen extends StatelessWidget {
  const UpdatepasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Password",
          style: TextStyle(
            fontSize: 21.sp,
            color: Theme.of(context).colorScheme.onSecondary
          ),
        ),
        
      ),
      
      body: GestureDetector(
        onTap: (){
            FocusScope.of(context).unfocus();
          },
        child: SingleChildScrollView(
          child: SizedBox(
            height: 650.h,
            child: Padding(
              padding:  EdgeInsets.all(20.w),
              child: Consumer<UpdatepasswordProvider>(
                builder: (context,provider,child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Form(
                        key: provider.formKey,
                        child:
                        Padding(
                          padding:  EdgeInsets.all(0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                    
                              SizedBox(height: 25.h,),
                              Text("Old Password",style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),),                        
                              SizedBox(height: 4.h,),                        
                              CustomPasswordTextFormField(
                                controller: provider.oldPasswordController, 
                                hintText: "old password",
                                validator: provider.passwordValidator,
                              ),

                              SizedBox(height: 14.h,),
                              Text("New Password",style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),),                        
                              SizedBox(height: 4.h,),                        
                              CustomPasswordTextFormField(
                                controller: provider.newPasswordController, 
                                hintText: "new password",
                                validator: provider.passwordValidator,
                              ),

                              SizedBox(height: 14.h,),
                              Text("Confirm New Password",style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),),                        
                              SizedBox(height: 4.h,),                        
                              CustomPasswordTextFormField(
                                controller: provider.reEnterNewPasswordController, 
                                hintText: "confirm new password",
                                validator: provider.reEnterpasswordValidator,
                              ), 
                                    
                                    
                              
                              
                              SizedBox(height: 25.h,),
                              //login button
                              Column(
                                children: [
                                  provider.updatePasswordisloading==false?
                                  Center(
                                    child: CustomButton(text:"Update",
                                    onPressed: () {
                                      provider.updatePasswordButton(context);
                                    },
                                    ),
                                  ):
                                  Center(child: CircularProgressIndicator())
                                ],
                              )
                              
                            ],
                                    
                          ),
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