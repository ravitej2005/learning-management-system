import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/components/snackbar.dart';
import 'package:learning_management_system/pages/authPage.dart';
import 'package:lottie/lottie.dart';

class EmailVerifyPage extends StatefulWidget {
  final User user;
  const EmailVerifyPage(this.user, {super.key});

  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  bool isVerified = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Start a timer to check email verification
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        await widget.user.reload(); // Reload user data
        if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
          setState(() {
            isVerified = true;
          });
          timer.cancel(); // Stop checking

          // Navigate to AuthPage if the widget is still mounted
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                displaySnackBar(
                  context,
                  "Account created Successfully..!!",
                  Icons.verified,
                );
                return AuthPage();
              }),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          // ✅ Add ScrollView to prevent overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/Animation-email-check.json', // Your Lottie animation file
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                "Verify Your Email!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16), // ✅ Add padding to prevent edge issues
                child: Text(
                  "A verification link has been sent to your email.\nPlease check and verify.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              isVerified
                  ? const Text(
                      "✅ Email Verified! Redirecting...",
                      style: TextStyle(fontSize: 18, color: Colors.green),
                    )
                  : const Text(
                      "Waiting for verification...",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
