import 'package:flutter/material.dart';
 // Ensure this file is correctly located in the 'pages' folder
import 'pages/landing.dart'; // Ensure this file is correctly located in the 'pages' folder
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
      home: SplashScreen(), // Set SignInScreen as the home screen
    );
  }
}
