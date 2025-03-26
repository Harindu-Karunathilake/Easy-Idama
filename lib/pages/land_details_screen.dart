import 'package:flutter/material.dart';
import 'package:mad/models/Property_model.dart';  // Ensure you import your Property model

class LandDetailsScreen extends StatelessWidget {
  final Property property;

  const LandDetailsScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    // Convert createdAt to a formatted date string if it's available
    String formattedDate = property.createdAt != null
        ? _formatDate(property.createdAt.toDate()) 
        : 'N/A';

    return Scaffold(
      appBar: AppBar(
          title: Text(property.name,
          style: TextStyle(color: Colors.white,),  // Use property.name
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView for scrolling
        child: Column(
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
                    "Date Added: $formattedDate", // Display formatted date
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Description Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                property.description ?? "No description available.", // Use property.description
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20), // Space before features section

            // Features Section (Add any additional features you want to display)
            if (property.features != null && property.features!.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Features:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...property.features!.map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.check, color: Colors.green, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              feature,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

            const SizedBox(height: 20), // Additional space before the button

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
      ),
    );
  }

  // Function to format the date added (assuming it's a timestamp)
  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}'; // Example format
  }
}
