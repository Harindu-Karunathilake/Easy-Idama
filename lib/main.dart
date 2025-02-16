import 'package:flutter/material.dart';
import 'pages/signin.dart'; // Ensure this file is correctly located in the 'pages' folder

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
      home: SignInScreen(), // Set SignInScreen as the home screen
    );
  }
}
