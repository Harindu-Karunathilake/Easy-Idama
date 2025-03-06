import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTabChange;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: GNav(
          selectedIndex: selectedIndex,
          tabBackgroundColor: const Color(0xFF1471D3),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          gap: 8,
          onTabChange: onTabChange,
          
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.search, text: 'Search'),
            GButton(icon: Icons.favorite_border, text: 'Favorite'),
            GButton(icon: Icons.account_circle, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
