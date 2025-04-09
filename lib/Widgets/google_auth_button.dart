import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleAuthButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final Color bgcolor;
  final Color textcolor;
  const GoogleAuthButton(
      {required this.text,
      required this.onPressed,
      required this.bgcolor,
      required this.textcolor,
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/google-svgrepo-com.svg',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: textcolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
