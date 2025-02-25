import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // White background
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds spacing on sides
            child: Image.asset(
              'assets/onboard1.jpg',
              fit: BoxFit.contain, // Keeps the image proportionate
              width: 300, // Adjust width as needed
            ),
          ),
          const SizedBox(height: 20), // Spacing between image and text

          // Text below the image
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Find your ideal land \n using location & price \n filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Colors.black87, // Slightly softer black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
