import 'package:flutter/material.dart';
import 'signin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/landing_background.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Semi-transparent overlay to improve text visibility
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3), // Dark overlay
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(height: screenHeight * 0.5), // Adjusted spacing
                // Title Text
                const Text(
                  "Perfect choice for your future",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White color for better contrast
                  ),
                ),
                const SizedBox(height: 10), // Space below text
                // Subtitle Text
                const Text(
                  "Our properties are masterpieces for every client with lasting value.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20), // Additional spacing
                const Spacer(),
              ],
            ),
          ),
          // Continue Button at the Bottom
          Positioned(
            bottom: 20, // Adjust margin from the bottom
            left: 20, // Left padding
            right: 20, // Right padding
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the SignInScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF1471D3),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
