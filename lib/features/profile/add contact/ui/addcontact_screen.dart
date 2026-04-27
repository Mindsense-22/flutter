import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_emailtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/profile/add%20contact/logic/addcontact_provider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
import 'package:mindsense_app/features/profile/update%20password/logic/updatepassword_provider.dart';
import 'package:provider/provider.dart';

class AddcontactScreen extends StatelessWidget {
  const AddcontactScreen({super.key});
  
  @override
   Widget build(BuildContext context) {
    var profileProvider=context.read<ProfileScreenProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Contact",
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
              child: Consumer<AddcontactProvider>(
                builder: (context,provider,child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      profileProvider.trustedContactemail==null&&profileProvider.trustedContactname==null?
                      Form(
                        key: provider.formKey,
                        child:
                        Padding(
                          padding:  EdgeInsets.all(0.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                    
                              SizedBox(height: 25.h,),
                              Text("Contact Name",style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),),                        
                              SizedBox(height: 4.h,),                        
                              CustomTextFormField(
                                controller: provider.contactName, 
                                hintText: "type contact name",
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
                              Text("Relationship",style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),),                        
                              SizedBox(height: 4.h,),                        
                              CustomTextFormField(
                                controller: provider.contactRelationship, 
                                hintText: "type contact relationship",
                                Icon: Padding(
                                  padding: const EdgeInsets.all(11.0),
                                  child:
                                   Icon(Icons.family_restroom,
                                   size: 22.sp,
                                   ),                                   
                                ),
                                validator: provider.nameValidator,
                              ),

                              SizedBox(height: 14.h,),
                              Text("Email",style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),),                        
                              SizedBox(height: 4.h,),                        
                              CustomEmailTextFormField(
                                controller: provider.contactEmail, 
                                hintText: "type contact email",
                                validator: provider.emailValidator,
                              ), 
                                    
                                    
                              
                              
                              SizedBox(height: 25.h,),
                              //login button
                              Column(
                                children: [
                                  provider.addContactisloading==false?
                                  Center(
                                    child: CustomButton(text:"Add Contact",
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
                      ):
                      Container(
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff1E293B),
                        ),
                        child: Column(                          
                          children: [
                            Row(
                              children: [
                                Text(
                                  profileProvider.trustedContactname??" ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  profileProvider.trustedContactrelationship??" ",
                                  style: TextStyle(
                                    color: AppColers.primaryColor,
                                    fontSize: 16.sp
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              profileProvider.trustedContactemail??" ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp
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