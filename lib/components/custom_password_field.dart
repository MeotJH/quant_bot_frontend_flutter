import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/core/colors.dart';

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<CustomPasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = widget.controller;
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.gray40),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.black),
        ),
      ),
      controller: passwordController,
    );
  }
}
