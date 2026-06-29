import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';

class AddcontactProvider extends ChangeNotifier{
  final formKey = GlobalKey<FormState>();
  TextEditingController contactName=TextEditingController();
  TextEditingController contactEmail=TextEditingController();
  TextEditingController contactRelationship=TextEditingController();
  bool addContactisloading=false;
  
  
  void changeAddContactIsLoading(val) {
    addContactisloading = val;
    notifyListeners();
  }
  
  String ? emailValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }
    if (!val.endsWith("@gmail.com")) {
      return "Email must end with @gmail.com";
    }
    
    
    return null;
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

  String ? relationshipValidator(String ? val){
    if(val!.isEmpty){
      return "fill The Field";                          
    }    
    return null;
  }

  Future<void> updatePasswordButton(context) async {
    if (formKey.currentState!.validate()) {
      changeAddContactIsLoading(true);
      log("Form is valid");      
      try {      
        
        await ProfileScreenProvider().addContact(
          contactName: contactName.text, 
          contactEmail: contactEmail.text, 
          relationship: contactRelationship.text
        );

        contactName.clear();
        contactEmail.clear();
        contactRelationship.clear();
        if (!context.mounted) return;
        customSnackbar(context,false,"Connect Request Sent Succesfuly");
        
        changeAddContactIsLoading(false);
      } catch (e) {
        log("Update Password failed");
        changeAddContactIsLoading(false);
        if (!context.mounted) return;
        customSnackbar(context,true,"AuthService.apiMessege");
        
      }

    } else {
      log("Form is NOT valid");
      if (!context.mounted) return;
      customSnackbar(context,true,"Form Is NOT Valid");
      
    }
  } 

  void resetProvider() {
    contactName.clear();
    contactEmail.clear();
    contactRelationship.clear();
    addContactisloading = false;
    notifyListeners();
  }
}