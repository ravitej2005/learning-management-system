import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/components/snackbar.dart';
import 'package:learning_management_system/pages/TeacherOnboardingScreen.dart';

class Homepage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const Homepage({super.key, required this.userData});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isChecked = false;

  void _showTeacherDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Become a Teacher",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Join us as a teacher and start sharing knowledge with students! You'll be able to create courses, manage assignments, and interact with learners.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const Text(
                    "Terms & Conditions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  const Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        "1. You will be responsible for creating and maintaining high-quality course content.\n\n"
                        "2. You must ensure the accuracy and relevancy of your courses.\n\n"
                        "3. You must adhere to community guidelines and maintain respectful communication with students.\n\n"
                        "4. 90% of course revenue will go to you, while 10% will be retained by the platform as an administrative fee.\n\n"
                        "5. Any disputes regarding payments will be handled as per the platform's dispute resolution policy.\n\n"
                        "6. Courses violating academic integrity or platform rules will be removed.\n\n"
                        "7. Refunds will be processed based on platform policies, and disputes will be resolved by the admin team.\n\n"
                        "8. Your account may be suspended if found violating platform policies.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "I agree to the terms and conditions.",
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isChecked
                        ? () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherOnboardingScreen(
                                    userData: widget.userData,
                                  ),
                                ));
                            // Navigate to teacher authentication screen
                          }
                        : null,
                    child: const Text("Join as Teacher"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("in build homepage ${widget.userData}");

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              displaySnackBar(context, "Logged Out..!!", Icons.flutter_dash);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.userData?['fullname'] ?? "Welcome",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showTeacherDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Become A Teacher",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
