import 'package:flutter/material.dart';
import 'package:learning_management_system/Widgets/auth_button.dart';
import 'package:learning_management_system/Screens/signin.dart';
import 'package:learning_management_system/Screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _setFirstLaunch();
  }

  Future<void> _setFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return signInScreen;
                          },
                        ),
                        (route) => false,
                      );
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return signUpScreen;
                          },
                        ),
                        (route) => false,
                      );
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
