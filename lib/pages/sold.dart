import 'package:flutter/material.dart';

class SoldPage extends StatelessWidget {
  const SoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sold Items')),
      body: const Center(
        child: Text('Sold Items Page Content Here'),
      ),
    );
  }
}
