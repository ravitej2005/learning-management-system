import 'package:flutter/material.dart';

class AuthTextfield extends StatefulWidget {
  final void Function()? onTap;
  final bool floatingLable;
  final void Function(String)? onChanged;
  final bool obscureText;
  final String? labelText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const AuthTextfield({
    this.onTap,
    this.floatingLable = true,
    this.onChanged,
    required this.obscureText,
    required this.labelText,
    required this.validator,
    required this.controller, // Accept the onChanged callback
    super.key,
  });

  @override
  State<AuthTextfield> createState() => _AuthTextfieldState();
}

class _AuthTextfieldState extends State<AuthTextfield> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText ? !isPasswordVisible : isPasswordVisible,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
      floatingLabelBehavior: widget.floatingLable ? FloatingLabelBehavior.auto :FloatingLabelBehavior.never,
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
              )
            : null,
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 19,
        ),
        labelStyle: const TextStyle(
          color: Color.fromARGB(124, 0, 0, 0),
          fontSize: 17,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        label: Text(widget.labelText!),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
