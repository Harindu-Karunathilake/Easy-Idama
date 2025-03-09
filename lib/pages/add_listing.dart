import 'package:flutter/material.dart';

class AddListingPage extends StatelessWidget {
  const AddListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Listing')),
      body: const Center(
        child: Text('Add Listing Page Content Here'),
      ),
    );
  }
}
