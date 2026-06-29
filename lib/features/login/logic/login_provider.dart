import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_snackbar.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/home/logic/homescreenprovider.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';
import 'package:provider/provider.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController loginEmailController =TextEditingController();
  TextEditingController loginpasswordController =TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isloading=false;
  bool islogined=false;

  chaneIsloading(val){
    isloading=val;
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

  String ? passwordValidator(String ? val){
    if(val==null||val.isEmpty){
    return "fill The Field";                          
    }
    if(val.length<8){
      return "password must be more than 8 charachter";
    }
    return null;
  }


  Future<void> loginButton(context) async {
    if (formKey.currentState!.validate()) {
      log("Form is valid");
      chaneIsloading(true);
      try {
        final result = await AuthService.login(
          email: loginEmailController.text,
          password: loginpasswordController.text,
        );
        
        await SharedPreferencesitem.setString("token", result.token);
        
        await SharedPreferencesitem.setString("userEmail", loginEmailController.text);
        if (!context.mounted) return;        
        customSnackbar(context,false,"Login successful !");
        log(result.status);
        
        
        chaneIsloading(false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false,
        );
        

      } catch (e) {
        chaneIsloading(false);
        log(e.toString());
        if (!context.mounted) return;
        customSnackbar(context,true,e.toString());
        
      }

    } else {
      log("Form is NOT valid");
      if (!context.mounted) return;
      customSnackbar(context,true,"Form is not valid");
      
    }
  }
  void resetProvider() {
    loginEmailController.clear();
    loginpasswordController.clear();
    isloading = false;
    islogined = false;
    notifyListeners();
  }
}





