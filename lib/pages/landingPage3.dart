import 'package:flutter/material.dart';
import 'package:learning_management_system/components/auth_button.dart';
import 'package:learning_management_system/pages/signin.dart';
import 'package:learning_management_system/pages/signup.dart';

class LandingPage3 extends StatefulWidget {
  const LandingPage3({super.key});

  @override
  State<LandingPage3> createState() => _LandingPage3State();
}

class _LandingPage3State extends State<LandingPage3> {
  late Widget signInScreen;
  late Widget signUpScreen;

  @override
  void initState() {
    super.initState();
    signInScreen = SignIn();
    signUpScreen = SignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AuthButton(
                    bgcolor: Colors.black,
                    textcolor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return signInScreen;
                        },
                      ));
                    },
                    text: "Sign In",
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: AuthButton(
                    bgcolor: Colors.white,
                    textcolor: Colors.black,
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return signUpScreen;
                        },
                      ));
                    },
                    text: "Sign Up",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
