import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindsense_app/core/Api/authservice.dart';
import 'package:mindsense_app/core/shared%20prefrances/sharedprefrances.dart';
import 'package:mindsense_app/features/main_nav/ui/main_screen.dart';

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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1250),
            content: Text(
              "Login successful !",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          
          SnackBar(
            duration: Duration(milliseconds: 1250),
            content: Text(e.toString(),style: TextStyle(
              color: Colors.white
            ),),
            backgroundColor: Colors.red,
          ),
        );
      }

    } else {
      log("Form is NOT valid");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Form is not valid",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }
  }
  
}





    
//  void loginButton(context) {
//     if (formKey.currentState!.validate()) {
//       log("Form is valid");
//       ScaffoldMessenger.of(context).showSnackBar(
//        SnackBar(
//         content: Text("Form is valid",style: TextStyle(
//           color: Colors.white
//         ),),
//         backgroundColor: Colors.black,
//        )
//       );
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen(),), (route) => false,);
//       SharedPreferencesitem.setString("token", "111111");
//       SharedPreferencesitem.setString("gmail", loginEmailController.text);
//     }
//     else {
//       log("Form is NOT valid");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//         content: Text("Form is not valid",style: TextStyle(
//           color: Colors.white
//         ),),
//         backgroundColor: Colors.black,
//         )
//       );
//     }
//   }

