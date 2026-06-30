import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_button.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_emailtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/profile/add%20contact/logic/addcontact_provider.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';
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
                        height: 170.h,   
                        
                        padding: EdgeInsets.all(12.w), 
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff1E293B), Color(0xff0F172A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24.r), 
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05), 
                            width: 1,
                          ),
                          
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: AppColers.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.shield_outlined, 
                                color: AppColers.primaryColor,
                                size: 28.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),                             

                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          profileProvider.trustedContactname!.toUpperCase() ?? "No Name Set",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19.sp, 
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: AppColers.primaryColor,
                                          borderRadius: BorderRadius.circular(30.r),
                                        ),
                                        child: Text(
                                          (profileProvider.trustedContactrelationship ?? "Contact").toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black, 
                                            fontSize: 10.sp,
                                            
                                            letterSpacing: 1.0, 
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  
                                  Text(
                                    "TRUSTED EMAIL ADDRESS",
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),                                  
                                  
                                  Text(
                                    profileProvider.trustedContactemail ?? "No Email Linked",
                                    style: TextStyle(
                                      color: Colors.white70, 
                                      fontSize: 15.sp, 
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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