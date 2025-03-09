import 'package:flutter/material.dart';

class LandDetailsScreen extends StatelessWidget {
  final Map<String, String> property;

  const LandDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property["name"]!),
        backgroundColor: const Color(0xFF1471D3),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Land Image
          Image.asset(
            property["image"]!,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 10),

          // Land Name & Date Added
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property["name"]!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Date Added: ${property["dateAdded"] ?? "N/A"}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              property["description"] ?? "No description available.",
              style: const TextStyle(fontSize: 16),
            ),
          ),

          const Spacer(), // Pushes the button to the bottom

          // Book Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add your booking logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1471D3),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Book",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
