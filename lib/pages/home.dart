import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        tabBackgroundColor: const Color(0xFF1471D3),
        gap: 8,
        tabs: [
          GButton(icon: Icons.home,
          text: 'Home',),
          GButton(icon: Icons.search,
          text: 'Search',),
          GButton(icon: Icons.favorite_border,
          text: 'Favorite',),
          GButton(icon: Icons.account_circle,
          text: 'Profile',),

        ]
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
