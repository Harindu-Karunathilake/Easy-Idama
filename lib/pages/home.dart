import 'package:flutter/material.dart';
import 'package:mad/pages/head_parts.dart';
import 'package:mad/widgets/navbar.dart';
// Import HeaderParts
import 'package:mad/pages/search.dart';
import 'package:mad/pages/favorite.dart';
import 'package:mad/pages/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onTabChange(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  FavoritesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0), // No appbar
        child: Container(),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 0,
        onTabChange: (index) => _onTabChange(context, index),
      ),
      body: const HeaderParts(), // Use HeaderParts widget as body
    );
  }
}