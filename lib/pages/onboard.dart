import 'package:flutter/material.dart';
import 'package:mad/pages/intro_screens/intro_page1.dart';
import 'package:mad/pages/intro_screens/intro_page2.dart';
import 'package:mad/pages/intro_screens/intro_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mad/pages/landing.dart'; // Ensure correct import

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding screens
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children:  [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),

          // Dot indicator & Navigation buttons
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip button
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SplashScreen(property: {},),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                // Dot indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.blue,
                  ),
                ),

                // Next / Done button
                GestureDetector(
                  onTap: () {
                    if (onLastPage) {
                      // If last page, navigate to Landing Page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(property: {},),
                        ),
                      );
                    } else {
                      // Move to the next page
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(
                    onLastPage ? 'Done' : 'Next',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
