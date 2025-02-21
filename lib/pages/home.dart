import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust padding for different screens
  child: GNav(
    backgroundColor: Colors.white, // Set a background color if needed
    color: Colors.grey[800], // Default icon color
    activeColor: Colors.white, // Active icon/text color
    tabBackgroundColor: const Color(0xFF1471D3), // Background color when selected
    gap: 8, // Space between icon and text
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Makes the navbar responsive
    tabBorderRadius: 20, // Rounded edges for tabs
    curve: Curves.easeInOut, // Smooth animation effect
    haptic: true, // Provides haptic feedback on click
    tabs: const [
      GButton(icon: Icons.home, text: 'Home'),
      GButton(icon: Icons.search, text: 'Search'),
      GButton(icon: Icons.favorite_border, text: 'Favorite'),
      GButton(icon: Icons.account_circle, text: 'Profile'),
    ],
  ),
),
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text(
          'Welcome to the Home Page!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
