import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/onboard.dart'; // Ensure this file exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures widget binding is initialized

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: '1:228865583868:android:d719a23e6d5c94ecf0c579',
        apiKey: 'AIzaSyAWGN1-6I5uUTZWaUBYvmL7pZH0B-NZ5KA', // API Key from json
        projectId: 'land-test-1fee6', // Project ID from json
        messagingSenderId: '228865583868', // Sender ID from json
        storageBucket: 'land-test-1fee6.firebasestorage.app', // Storage Bucket from json
      ),
    ); // Initialize Firebase with options
    print("Firebase Initialized");
  } catch (e) {
    print("Firebase Initialization Error: $e");
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
      home: OnboardingScreen(), // Show Onboarding first
    );
  }
}
