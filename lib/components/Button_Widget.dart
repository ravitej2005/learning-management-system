import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double? fontSize;
  final Color bgcolor;
  final Color textcolor;
  final String text;
  final void Function()? onPressed;
  const ButtonWidget({
    required this.bgcolor,
    this.fontSize = 22,
    required this.textcolor,
    required this.onPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: const Color.fromARGB(166, 0, 0, 0),
          disabledForegroundColor: const Color.fromARGB(160, 0, 0, 0),
          foregroundColor: bgcolor,
          backgroundColor: bgcolor,
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
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
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: textcolor,
          ),
        ),
      ),
    );
  }
}
