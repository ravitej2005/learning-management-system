import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_management_system/components/auth_button.dart';
import 'package:learning_management_system/components/auth_textfield.dart';
import 'package:learning_management_system/components/google_auth_button.dart';
import 'package:learning_management_system/components/snackbar.dart';
import 'package:learning_management_system/pages/authPage.dart';
import 'package:learning_management_system/pages/emailVerifyPage.dart';
import 'package:learning_management_system/pages/signin.dart';

// import 'package:remixicon/remixicon.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void dispose() {
    fullname.clear();
    username.clear();
    email.clear();
    password.clear();
    confirmpassword.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  String generateUsername(String email) {
    String base = email.split('@')[0];
    int randomNum = Random().nextInt(9999); // Random 4-digit number
    return "$base$randomNum";
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();

      // Force sign-out of any previous account
      await googleSignIn.signOut();
      setState(() {
        isLoading = true; // Start loading
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return; // Stop execution if user cancels sign-in
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userCredential.user?.email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        displaySnackBar(
          context,
          "Account Created Successfully..!!",
          Icons.verified,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'fullname': userCredential.user?.displayName,
          'username': generateUsername(userCredential.user?.email ?? ''),
          'email': userCredential.user?.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      setState(() {
        isLoading = false; // Stop loading before navigation
      });

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return const AuthPage();
          }),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      print(e.toString());
    }
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final fullname = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
  bool? isUsernameAvailable;
  bool isLoading = false;

  void checkUsername(String username) async {
    bool? isUsernameAvailable = await checkUsernameExists(username);
    setState(() {
      this.isUsernameAvailable = isUsernameAvailable;
    });
  }

  Future<bool?> checkUsernameExists(String username) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username.trim())
        .get();

    return querySnapshot.docs.isEmpty ? true : false;
  }

  Future<void> registerUser(BuildContext context) async {
    final validateForm = _formkey.currentState!.validate();
    if (validateForm) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      if (password.text != confirmpassword.text) {
        Navigator.pop(context);
        displaySnackBar(context, "Passwords don't match...!!!", Icons.error);
      } else {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email.text.trim(), password: password.text.trim());

          String? uid = userCredential.user?.uid;
          if (uid != null) {
            await FirebaseFirestore.instance.collection('users').doc(uid).set({
              'fullname': fullname.text.trim(),
              'username': username.text.trim(),
              'email': email.text.trim(),
              'createdAt': FieldValue.serverTimestamp(),
            });

            await userCredential.user?.sendEmailVerification();

            if (mounted) {
              Navigator.pop(context);
            }
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return EmailVerifyPage(userCredential.user!);
              },
            ));
          }
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context); // Close loading dialog on error
          displaySnackBar(context, e.code, Icons.error);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text(
                    "Create an account to begin your Learning Journey",
                    style: TextStyle(
                      fontSize: 15.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 25,
                  ),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthTextfield(
                          obscureText: false,
                          labelText: "Full Name",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "*required";
                            } else if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)*$')
                                .hasMatch(value.trim())) {
                              return 'Name can only contain letters and spaces';
                            } else {
                              return null;
                            }
                          },
                          controller: fullname,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthTextfield(
                          obscureText: false,
                          labelText: "Username",
                          validator: (value) {
                            if (value!.trim() == "") {
                              return "*required";
                            } else if (!RegExp(r'^[a-z0-9]+$')
                                .hasMatch(value.trim())) {
                              return 'Only lowercase letters & numbers allowed';
                            } else if (value.trim().length < 5) {
                              return 'Username must have at least 5 characters';
                            } else {
                              checkUsername(value.trim());
                              return isUsernameAvailable == false
                                  ? "Username already taken"
                                  : null;
                            }
                          },
                          controller: username,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthTextfield(
                          obscureText: false,
                          labelText: "Email Address",
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
                        const SizedBox(
                          height: 20,
                        ),
                        AuthTextfield(
                          obscureText: true,
                          labelText: "Password",
                          validator: (value) {
                            if (value!.trim() == "") {
                              return "*required";
                            } else if (value.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                          controller: password,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthTextfield(
                          obscureText: true,
                          labelText: "Confirm Password",
                          validator: (value) {
                            if (value!.trim() == "") {
                              return "*required";
                            } else {
                              return null;
                            }
                          },
                          controller: confirmpassword,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AuthButton(
                          textcolor: Colors.white,
                          bgcolor: Colors.black,
                          onPressed: () => registerUser(context),
                          text: "Sign Up",
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Or Sign Up with",
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GoogleAuthButton(
                          text: "Sign Up With Google",
                          onPressed: () {
                            signUpWithGoogle(context);
                          },
                          bgcolor: Colors.white,
                          textcolor: Colors.black,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return SignIn();
                                  },
                                ));
                              },
                              child: const Text(
                                "Sign In Here",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.6), // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
          ),
      ],
    );
  }
}
