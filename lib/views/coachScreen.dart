import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _logout(context), // Call the logout function
        ),
        title: const Text("Coach Screen"),
      ),
      body: const Center(
        child: Text("Coach Screen Page"),
      ),
    );
  }
  // Logout function
  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()), // Replace with your login screen widget
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }
}
