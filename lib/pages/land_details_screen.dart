import 'package:flutter/material.dart';
import 'package:mad/models/Property_model.dart';  // Ensure you import your Property model

class LandDetailsScreen extends StatelessWidget {
  final Property property;

  const LandDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),  // Use property.name
        backgroundColor: const Color(0xFF1471D3),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Land Image
          Image.network(
            property.imageUrls.isNotEmpty ? property.imageUrls.first : '', // Use network image
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
                  property.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Date Added: ${property.createdAt ?? 'N/A'}", // Use property.dateAdded
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
              property.description ?? "No description available.", // Use property.description
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
