import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Color bgcolor;
  final Color textcolor;
  final String text;
  final void Function()? onPressed;
  const AuthButton(
      {required this.bgcolor,
      required this.textcolor,
      required this.onPressed,
      required this.text,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: bgcolor,
          backgroundColor: bgcolor,
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 38,
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          side: const BorderSide(
            color: Colors.black,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textcolor,
          ),
        ),
      ),
    );
  }
}
