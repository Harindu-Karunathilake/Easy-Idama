import 'package:flutter/material.dart';
import 'onboard.dart'; // Ensure this path is correct

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // Delay navigation to the Onboarding screen after 3 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _navigateToOnboarding();
      }
    });
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(_fadeRoute(const OnboardingScreen()));
  }

  // Custom fade transition
  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 700), // Adjust duration for smoother effect
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logo.jpg', // Ensure this logo exists in assets
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20), // Spacing between logo and loader
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Customize color
            ),
          ],
        ),
      ),
    );
  }
}
