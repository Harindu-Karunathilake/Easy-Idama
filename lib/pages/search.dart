import 'package:flutter/material.dart';
import 'package:mad/widgets/navbar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 1,
        onTabChange: (index) {
          // You can add any logic here if needed when the tab changes.
          // For example, you might want to update some state.
          print('Tab changed to index: $index');
        },
      ),
      body: const Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    );
  }
}