import 'package:flutter/material.dart';
import 'package:mad/pages/head_parts.dart';
import 'package:mad/widgets/navbar.dart';
import 'package:mad/pages/search.dart';
import 'package:mad/pages/favorite.dart';
import 'package:mad/pages/profile.dart';

class HomePage extends StatelessWidget {
  final String? successMessage;
  const HomePage({super.key, this.successMessage});

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
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
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
    // Show success message as a Snackbar if it's not null
    if (successMessage != null) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage!),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }

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
