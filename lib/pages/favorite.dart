import 'package:flutter/material.dart';
import 'package:mad/widgets/navbar.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 2,
        onTabChange: (index) {
          // You can add any logic here if needed when the tab changes.
          // For example, you might want to update some state.
          print('Tab changed to index: $index');
        },
      ),
      body: const Center(child: Text('Favorite Page', style: TextStyle(fontSize: 24))),
    );
  }
}