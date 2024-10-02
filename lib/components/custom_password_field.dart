import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/core/colors.dart';

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({
    super.key,
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  State<CustomPasswordTextField> createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validatePassword);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePassword);
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      print('this is widget tex ${widget.errorText}');
      _errorText = widget.errorText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        errorText: _errorText,
      ),
      controller: widget.controller,
    );
  }
}
