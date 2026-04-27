import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(          
          SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromARGB(255, 20, 116, 23),
            content: Text("Connect Request Sent Succesfuly ",style: TextStyle(
              color: Colors.white
            ),),            
          ),
        );
        changeAddContactIsLoading(false);
      } catch (e) {
        log("Update Password failed");
        changeAddContactIsLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(          
          SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
            content: Text(AuthService.apiMessege,style: TextStyle(
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
          content: Text("Form Is NOT Valid",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: Colors.red,
        ),
      );
    }
  } 



}