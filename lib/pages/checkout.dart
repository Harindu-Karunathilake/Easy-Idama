import 'package:flutter/material.dart';
import 'package:mad/pages/payment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatelessWidget {
  final String listingId; // Receive the listing ID

  const CheckoutScreen({super.key, required this.listingId});

  // Fetch property details from Firestore
  Future<DocumentSnapshot> fetchPropertyDetails() async {
    var propertyRef = FirebaseFirestore.instance.collection('Listings').doc(listingId);
    return await propertyRef.get();
  }

  // Function to launch URLs in the browser
  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Checkout",
          style: TextStyle( fontSize: 22, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<DocumentSnapshot>(
            future: fetchPropertyDetails(), // Fetch data from Firestore
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text("No data available"));
              }

              var propertyData = snapshot.data!.data() as Map<String, dynamic>;

              // Extract property data from Firestore document
              final Property property = Property.fromMap(propertyData);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title section
                    const Text(
                      "Property Details",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 16),
                    buildInfoCard(property),

                    const SizedBox(height: 16),
                    const Text(
                      "Images",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 8),
                    buildImageGallery(property),

                    const SizedBox(height: 16),
                    const Text(
                      "Documents",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 8),
                    buildDocumentLinks(property),

                    const SizedBox(height: 16),
                    buildProceedButton(context, property),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Info card for displaying basic details like name, category, price
  Widget buildInfoCard(Property property) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
              text: "Title: ",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent, fontFamily: 'Poppins'),
              children: [
              TextSpan(
              text: property.name,
              style: const TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.black),
              ),
              ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
              text: "Category: ",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent, fontFamily: 'Poppins'),
              children: [
              TextSpan(
              text: property.category,
              style: const TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.black),
              ),
              ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
              text: "Location: ",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent, fontFamily: 'Poppins'),
              children: [
              TextSpan(
              text: property.location,
              style: const TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.black),
              ),
              ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
              text: "Price: ",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent, fontFamily: 'Poppins'),
              children: [
              TextSpan(
              text: "\$${property.price}",
              style: const TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Poppins', color: Colors.black),
              ),
              ],
              ),
            ),
            const SizedBox(height: 16),
            const Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            Text(property.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Features:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            for (var feature in property.features)
              Text("• $feature", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Image Gallery for property images
  Widget buildImageGallery(Property property) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: property.imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                property.imageUrls[index],
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  // Document Links section for Property Deed and Plan
  Widget buildDocumentLinks(Property property) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            if (property.propertyDeedUrl.isNotEmpty) {
              _launchURL(property.propertyDeedUrl);
            }
          },
          child: const Text(
            "Property Deed",
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ),
        TextButton(
          onPressed: () {
            if (property.propertyPlanUrl.isNotEmpty) {
              _launchURL(property.propertyPlanUrl);
            }
          },
          child: const Text(
            "Property Plan",
            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  // Button to proceed with payment
  Widget buildProceedButton(BuildContext context, Property property) {
    return Center(
      child: ElevatedButton(
      onPressed: () {
        Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PayPalPaymentScreen( ), // Pass listingId and amount
                    ),
                  );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        "Proceed to Payment",
        style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      ),
    );
  }
}

class Property {
  final String id;
  final String category;
  final String description;
  final List<String> imageUrls;
  final String name;
  final String price;
  final String propertyDeedUrl;
  final String propertyPlanUrl;
  final String userId;
  final String location;
  final List<String> features;

  Property({
    required this.id,
    required this.category,
    required this.description,
    required this.imageUrls,
    required this.name,
    required this.price,
    required this.propertyDeedUrl,
    required this.propertyPlanUrl,
    required this.userId,
    required this.location,
    required this.features,
  });

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      propertyDeedUrl: map['propertyDeedUrl'] ?? '',
      propertyPlanUrl: map['propertyPlanUrl'] ?? '',
      userId: map['userId'] ?? '',
      location: map['location'] ?? '',
      features: List<String>.from(map['features'] ?? []),
    );
  }
}
