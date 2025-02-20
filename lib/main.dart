import 'package:flutter/material.dart';
import 'pages/onboard.dart'; // Ensure this file exists


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: OnboardingScreen(), // Show Onboarding first
    );
  }
}
