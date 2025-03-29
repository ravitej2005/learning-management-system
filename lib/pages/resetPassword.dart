import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/components/auth_button.dart';
import 'package:learning_management_system/components/auth_textfield.dart';
import 'package:learning_management_system/components/snackbar.dart';
import 'package:learning_management_system/pages/signin.dart';
import 'package:remixicon/remixicon.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Timer? timer;
  final email = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // For form validation

  Future<void> onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.text.trim());
        Navigator.pop(context);
        displaySnackBar(
          context,
          "Password reset link has been sent to your email",
          Remix.telegram_fill,
        );
        timer = Timer(
          const Duration(seconds: 6),
          () {
            email.clear();
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => const SignIn(),
              ),
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displaySnackBar(
          context,
          e.code,
          Remix.error_warning_fill,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Kindly enter your registered email",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Registered Email",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                AuthTextfield(
                  onTap: () {
                    timer?.cancel();
                  },
                  floatingLable: false,
                  obscureText: false,
                  labelText: "Email",
                  validator: (value) {
                    if (value!.trim() == "") {
                      return "*required";
                    }
                    String pattern =
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  controller: email,
                ),
                const SizedBox(height: 40),
                AuthButton(
                  bgcolor: Colors.black,
                  textcolor: Colors.white,
                  onPressed: () => onSubmit(context),
                  text: "Done",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
