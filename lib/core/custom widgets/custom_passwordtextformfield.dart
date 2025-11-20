import 'package:flutter/material.dart';
import 'package:mindsense_app/core/styles/colors.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  

  const CustomPasswordTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    
  });

  @override
  State<CustomPasswordTextFormField> createState() =>
      _CustomPasswordTextFormFieldState();
}

class _CustomPasswordTextFormFieldState
    extends State<CustomPasswordTextFormField> {
  bool locked = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: locked,  
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              locked = !locked;  
            });
          },
          icon: Icon(locked ? Icons.visibility_off_outlined : Icons.visibility_outlined),
        ),
        
        prefixIcon: Icon(Icons.lock_open_outlined),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: TextColers.secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
        filled: true,
        fillColor: AppColers.backgroundColor,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColers.primaryColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColers.primaryColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: widget.validator,
    );
  }
}
