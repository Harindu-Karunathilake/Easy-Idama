import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mad/pages/head_parts.dart';
import 'package:mad/pages/search_page.dart'; // Import the Search Page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: GNav(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) { // If search icon is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          }
        },
        tabBackgroundColor: const Color(0xFF1471D3),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        tabBorderRadius: 10,
        gap: 8,
        tabs: const [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.search, text: 'Search'),
          GButton(icon: Icons.favorite_border, text: 'Favorite'),
          GButton(icon: Icons.account_circle, text: 'Profile'),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: const [
            HeaderParts(), // Header section
          ],
        ),
      ),
    );
  }
}
