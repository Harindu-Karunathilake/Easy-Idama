import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_listing_3.dart'; // Import the next screen

class AddListing2 extends StatefulWidget {
  const AddListing2({super.key});

  @override
  _AddListing2State createState() => _AddListing2State();
}

class _AddListing2State extends State<AddListing2> {
  final TextEditingController _locationController = TextEditingController();

  Future<void> _saveLocation() async {
    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a location.")),
      );
      return;
    }

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Listings")
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String listingId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance.collection("Listings").doc(listingId).update({
          "location": _locationController.text.trim(),
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddListing3()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No listing found to update.")),
        );
      }
    } catch (e) {
      print("❌ Error updating location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving location: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Listing - Step 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Where is the location?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Enter the location',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveLocation,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
