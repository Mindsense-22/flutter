import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_passwordtextformfield.dart';
import 'package:mindsense_app/core/custom%20widgets/custom_textformfield.dart';
import 'package:mindsense_app/features/splash/ui/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:mindsense_app/core/custom widgets/custom_button.dart';
import 'package:mindsense_app/features/profile/logic/profile_screen_provider.dart';

class DeleteaccountScreen extends StatefulWidget {
  const DeleteaccountScreen({super.key});

  @override
  State<DeleteaccountScreen> createState() => _DeleteaccountScreenState();
}

class _DeleteaccountScreenState extends State<DeleteaccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (!_formKey.currentState!.validate()) return;
    final password = _passwordController.text.trim();
    final reason = _reasonController.text.trim();
    try {
     final response= await Provider.of<ProfileScreenProvider>(context, listen: false)
          .deleteAccount(password: password, reason: reason,mode: "hard");
      // After successful deletion, navigate back to login or pop all screens
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Account deleted successfully',style: TextStyle(color: Colors.white),)),
      );
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context) => SplashScreen(), ), (route) => false);
    } catch (e) {
      if (!mounted) return;
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(        
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error Ocoured in Deleting " ,style: TextStyle(color: Colors.white),)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Password"),
              SizedBox(height: 5.h,),
              CustomPasswordTextFormField(
                controller: _passwordController,
                hintText: 'Password',
                validator: (value) => (value == null || value.isEmpty) ? 'Password required' : null,
              ),
              const SizedBox(height: 12),
              Text("Reason"),
              SizedBox(height: 5.h,),
              CustomTextFormField(
                controller: _reasonController,
                hintText: 'Reason',
                validator: (value) => (value == null || value.isEmpty) ? 'Reason required' : null,
              ),

              const SizedBox(height: 24),
              CustomButton(
                text: 'Delete Account',
                onPressed: _deleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
