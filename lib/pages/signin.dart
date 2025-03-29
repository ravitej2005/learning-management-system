import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:remixicon/remixicon.dart';
import 'package:learning_management_system/components/auth_button.dart';
import 'package:learning_management_system/components/auth_textfield.dart';
import 'package:learning_management_system/components/google_auth_button.dart';
import 'package:learning_management_system/components/snackbar.dart';
import 'package:learning_management_system/pages/authPage.dart';
import 'package:learning_management_system/pages/resetPassword.dart';
import 'package:learning_management_system/pages/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loginFailed = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("User canceled Google sign-in.");
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
      print(userCredential.user);
    } catch (e) {
      print(e.toString());
    }
  }

  void loginUser(BuildContext context) async {
    bool validateForm = _formkey.currentState!.validate();
    if (validateForm) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        if (mounted) {
          Navigator.pop(context);
        }
        email.clear();
        password.clear();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const AuthPage();
            },
          ),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.pop(context);
        }
        displaySnackBar(context, e.code, Icons.error);
        print(e);
        setState(() {
          loginFailed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Sign In",
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                "Please Sign in with your account",
                style: TextStyle(
                  fontSize: 18,
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
                      labelText: "Email",
                      controller: email,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
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
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthTextfield(
                      obscureText: true,
                      labelText: "Password",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "*required";
                        } else {
                          return null;
                        }
                      },
                      controller: password,
                    ),
                    loginFailed
                        ? const SizedBox(
                            height: 10,
                          )
                        : const SizedBox.shrink(),
                    loginFailed
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ResetPassword();
                                    },
                                  ));
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 106, 106, 106),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthButton(
                      bgcolor: Colors.black,
                      textcolor: Colors.white,
                      onPressed: () => loginUser(context),
                      text: "Sign In",
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
                          "Or Sign In with",
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
                      text: "Sign In With Google",
                      onPressed: () {
                        loginWithGoogle();
                        print("Google Login");
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
                          "Dont't have an account?",
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
                                return const SignUp();
                              },
                            ));
                          },
                          child: const Text(
                            "Create Account Here",
                            style: TextStyle(
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
    );
  }
}