import 'package:flutter/material.dart';
import 'package:mad/widgets/navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 3,
        onTabChange: (index) {
          // You can add any logic here if needed when the tab changes.
          // For example, you might want to update some state.
          print('Tab changed to index: $index');
        },
      ),
      body: const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
    );
  }
}