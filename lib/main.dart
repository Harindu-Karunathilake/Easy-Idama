import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/onboard.dart'; 
import 'pages/home.dart'; // Import HomeScreen
import 'dart:developer'; // Dart's built-in logging

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures widget binding is initialized

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: '1:228865583868:android:d719a23e6d5c94ecf0c579',
        apiKey: 'AIzaSyAWGN1-6I5uUTZWaUBYvmL7pZH0B-NZ5KA', 
        projectId: 'land-test-1fee6', 
        messagingSenderId: '228865583868',
        storageBucket: 'land-test-1fee6.firebasestorage.app', 
      ),
    ); 
    log("Firebase Initialized");
  } catch (e) {
    log("Firebase Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const OnboardingScreen(), // Start with Onboarding
      routes: {
        '/home': (context) => const HomeScreen(), // Home Page
      },
    );
  }
}
