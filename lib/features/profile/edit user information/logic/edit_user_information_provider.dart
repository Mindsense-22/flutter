import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';

class EditUserInformationProvider extends ChangeNotifier {
  TextEditingController editNameController=TextEditingController();
  TextEditingController editAgeController=TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool editbuttonisloading=false;
  

  void changeEditButtonIsLoading(val) {
    editbuttonisloading = val;
    notifyListeners();
  }

  String ? nameValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if(val.length<2){
      return "Name Must Be Two Characters Or More";
    }
    return null;
  }

  String ? ageValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if (int.parse(val) <7) {
      return "Age must be 7 or greater";
    }
    return null;
  }

  String ? editFormValidator(String ? val){
    // if(editAgeController.text.isEmpty&&editNameController.text.isEmpty){
    //   return "fill Any Field To Confirm Edits";                          
    // }
    
    return null;
  }

  Future<void> editInfoButton(context) async {
    if (formKey.currentState!.validate()&&(editAgeController.text.isNotEmpty||editNameController.text.isNotEmpty)) {
      changeEditButtonIsLoading(true);
      log("Form is valid");
      if(editAgeController.text.isEmpty){
        editAgeController.text=SharedPreferencesitem.getInt("userAge").toString();
      }
      if(editNameController.text.isEmpty){
        editNameController.text=SharedPreferencesitem.getString("userName").toString();
      }
      try {    
        await ProfileScreenProvider().updateUserProfile(
          age: int.parse(editAgeController.text),
          name: editNameController.text,
          email: null,
        );       

        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Information updated"),
          ),
        );
        editAgeController.clear();
        editNameController.clear();
        changeEditButtonIsLoading(false);
      } catch (e) {
        log("Signup failed");
        changeEditButtonIsLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          
          SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
            content: Text(
              AuthService.apiMessege.isEmpty?
              "Edits Not Complete":
              AuthService.apiMessege,
              style: TextStyle(
              color: Colors.white
            ),),            
          ),
        );
      }

    } else {
      log("Form is NOT valid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 700),
          content: Text("Fill Any Field First",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}