import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/pages/Homepage.dart';
import 'package:learning_management_system/pages/emailVerifyPage.dart';
import 'package:learning_management_system/pages/signin.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show loading indicator
        } else if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null && !user.emailVerified) {
            user.sendEmailVerification();
            return EmailVerifyPage(user); // Navigate to email verification page
          }
          return Homepage(); // User is logged in
        } else {
          return SignIn(); // Show login page by default
        }
      },
    );
  }
}
