import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/Widgets/snackbar.dart';
import 'package:learning_management_system/Screens/authPage.dart';
import 'package:lottie/lottie.dart';
import 'package:remixicon/remixicon.dart';

class EmailVerifyPage extends StatefulWidget {
  final User user;
  const EmailVerifyPage(this.user, {super.key});

  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  bool isVerified = false;
  bool emailResent = false;
  int timeUntilResendMail = 35;
  late Timer timer;
  late Timer timer2;

  @override
  void initState() {
    super.initState();
    timer2 = Timer.periodic(
      const Duration(seconds: 1),
      (timer2) {
        if (timeUntilResendMail > 0) {
          if (mounted) {
            setState(() {
              timeUntilResendMail--;
            });
          }
        } else {
          timer2.cancel();
        }
      },
    );
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                displaySnackBar(
                  context,
                  "Account created Successfully..!!",
                  Icons.verified,
                );
                return const AuthPage();
              }),
              (route) => false,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    timer2.cancel();
    super.dispose();
  }

  Future<void> resendVerificationMail(BuildContext context) async {
    try {
      timer2.cancel();
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      print("widget.user ${widget.user}");
      await FirebaseAuth.instance.currentUser?.reload();
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (mounted) {
        Navigator.pop(
            context); // Close loading dialog only if widget is still mounted
      }
      displaySnackBar(
        context,
        "A new verification email has been sent.",
        Remix.mail_check_line,
      );
      setState(() {
        emailResent = true;
      });
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Ensure dialog is closed even on error
      }
      displaySnackBar(
        context,
        "Failed to send verification email. Try again.",
        Remix.error_warning_fill,
      );
      print("Error sending verification email: $e");
    }
  }

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
              const Text(
                "Didn't get the email ?",
                style: TextStyle(fontSize: 15),
              ),
              emailResent
                  ? const Text(
                      "Verification email has been resent ✅",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "You can ",
                          style: TextStyle(fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: timeUntilResendMail <= 0
                              ? () => resendVerificationMail(context)
                              : () {},
                          child: Text(
                            "Resend email ",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey,
                              decorationThickness: 2,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: timeUntilResendMail > 0
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                        timeUntilResendMail > 0
                            ? const Text(
                                "in...",
                                style: TextStyle(fontSize: 15),
                              )
                            : const SizedBox.shrink(),
                        timeUntilResendMail > 0
                            ? Text(
                                "$timeUntilResendMail sec",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
