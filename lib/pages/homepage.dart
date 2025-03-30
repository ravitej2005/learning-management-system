import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_management_system/components/snackbar.dart';

class Homepage extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const Homepage({super.key, required this.userData});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // getDocument();
  }

  // Future<void> getDocument() async {
  //   var userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(widget.userId!)
  //       .get();
  //   if (userDoc.exists) {
  //     setState(() {
  //       userData = userDoc.data() as Map<String, dynamic>;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              displaySnackBar(context, "Logged Out..!!", Icons.flutter_dash);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Text(widget.userData?['fullname'] ?? "Welcome"),
      ),
    );
  }
}
