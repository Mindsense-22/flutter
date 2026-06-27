import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mindsense_app/core/styles/colors.dart';
import 'package:mindsense_app/features/sign%20up/logic/signup_provider.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/signup_form_wid.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/signup_uppertext_wid.dart';
import 'package:mindsense_app/features/sign%20up/ui/widgets/tologin_widget.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupProvider(),
      child: Scaffold(
      
        appBar: AppBar(),
      
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(right: 18.w,left: 18.w,top: 0.h),
              child: Consumer<SignupProvider>(
                builder: (context,val,child) {
                  var provider=context.read<SignupProvider>();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,   
                    mainAxisAlignment: MainAxisAlignment.center,     
                    children: [

                      // upper text wid
                      SignupUppertextWid(),
                      SizedBox(height: 5.h,),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 110.w,
                            height: 110.w,
                            decoration: BoxDecoration(
                              color: Color(0xff2DD4BF).withValues(alpha: .2),
                              borderRadius: BorderRadius.circular(108.r),
                              border: Border.all(
                                color: AppColers.primaryColor.withValues(alpha: .3),
                                width: 2.w,
                              ),                
                            ),              
                          ),
                          Positioned(
                            top: 6.8,
                            child: Container(
                              width: 98.w,
                              height: 98.w,
                              decoration: BoxDecoration(                
                              borderRadius: BorderRadius.circular(108.r),                                
                            ),
                              child:
                                val.signUpPhotoPath==null?
                                SizedBox.shrink():
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(108.r),
                                  child: Image.file(
                                    File(val.signUpPhotoPath!),
                                    fit: BoxFit.cover,
                                    width: 98.w,
                                    height: 98.w,
                                  ),
                                )  ,                                              
                            ),            
                          ),
                          
                          Positioned(
                            bottom: 1.w,
                            right: 1.w,
                            child: InkWell(
                              onTap: () {
                                val.pickGalleryImage(context);
                              },
                              borderRadius: BorderRadius.circular(150.r),
                              splashColor: Colors.grey,
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: AppColers.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Color(0xff0B0F19),
                                    width: 2.w,
                                  ),                                   
                                ),
                                child: SvgPicture.asset("assets/images/camera_icon_black.svg",
                                  height: 16.h,
                                  width: 16.w,
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h,),

                      //signup form widget
                      SignupFormWid(provider: provider,context: context,),
                              
                      SizedBox(height: 5.h,),
                      
                      //to login widget  
                      TologinWidget(),
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