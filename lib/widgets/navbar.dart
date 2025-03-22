import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mad/pages/home.dart';
import 'package:mad/pages/search.dart';
import 'package:mad/pages/favorite.dart';
import 'package:mad/pages/profile.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTabChange;

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
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.5, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
        break;
      case 1:
        if (currentRoute != '/search') {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>  SearchPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.5, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
        break;
      case 2:
        if (currentRoute != '/favorite') {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>  FavoritesScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.5, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
        break;
      case 3:
        if (currentRoute != '/profile') {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.5, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GNav(
      selectedIndex: selectedIndex,
      tabBackgroundColor: const Color(0xFF1471D3),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      tabBorderRadius: 10,
      gap: 8,
      onTabChange: (index) {
        _onTabChange(context, index);
        onTabChange(index);
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