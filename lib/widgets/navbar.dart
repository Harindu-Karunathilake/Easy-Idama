import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mad/pages/home.dart';
import 'package:mad/pages/search.dart';
import 'package:mad/pages/favorite.dart';
import 'package:mad/pages/profile.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTabChange; // Store the callback function

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  void _onTabChange(BuildContext context, int index) {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? "";

    switch (index) {
      case 0:
        if (currentRoute != '/home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
        break;
      case 1:
        if (currentRoute != '/search') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        }
        break;
      case 2:
        if (currentRoute != '/favorite') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FavoritePage()),
          );
        }
        break;
      case 3:
        if (currentRoute != '/profile') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GNav(
      selectedIndex: selectedIndex, // Highlight the active tab
      tabBackgroundColor: const Color(0xFF1471D3),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      tabBorderRadius: 10,
      gap: 8,
      onTabChange: (index) {
        _onTabChange(context, index);
        onTabChange(index); // Also call the passed function
      },
      tabs: const [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.search, text: 'Search'),
        GButton(icon: Icons.favorite_border, text: 'Favorite'),
        GButton(icon: Icons.account_circle, text: 'Profile'),
      ],
    );
  }
}
