import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/pages/Homepage.dart';
import 'package:learning_management_system/pages/signin.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Map<String, dynamic>? userData;

  Future<Map<String, dynamic>?> getDocument(User user) async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      return null; // Return null if user document doesn't exist
    } catch (e) {
      print("Error fetching user document: $e");
      return null;
    }
  }

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
            return const SignIn();
          }
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  backgroundColor: Colors.white,
                );
              } else if (userSnapshot.hasData && userSnapshot.data!.exists) {
                return Homepage(
                    userData:
                        userSnapshot.data!.data() as Map<String, dynamic>);
              } else {
                return const SignIn(); // If Firestore doc doesn't exist yet, keep showing SignIn
              }
            },
          );
        } else {
          return const SignIn(); // Show login page by default
        }
      },
    );
  }
}
