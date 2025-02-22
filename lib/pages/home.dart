import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mad/pages/header_parts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        tabBackgroundColor: const Color(0xFF1471D3),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        tabBorderRadius: 10,
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
        
      body: ListView(
        children: [
          //for header parts
          HeaderParts()
        ],
      )
    );
  }
}
