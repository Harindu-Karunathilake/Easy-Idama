import 'package:flutter/material.dart';

class HeaderParts extends StatelessWidget {
  const HeaderParts({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures spacing between left & right
        children: [
          // Left Side - Location Icon & Text
          Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Padding inside the box
      decoration: BoxDecoration(
        //color: const Color.fromARGB(255, 241, 240, 240), // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1), // Border color & width
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.red), // Location Icon
          const SizedBox(width: 5), // Spacing
          const Text(
            "Colombo, Sri Lanka", // Replace with dynamic location if needed
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  ],
),

          // Right Side - Profile & Notification Icons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  // Handle Notification Tap
                },
              ),
              const SizedBox(width: 8), // Spacing
              CircleAvatar(
                radius: 18, // Adjust size as needed
                backgroundImage: AssetImage('assets/profile.jpg'), 
                
              ),
            ],
          ),
        ],
      ),
    );
  }
}
