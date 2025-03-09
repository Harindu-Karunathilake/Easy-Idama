import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'add_listing_2.dart'; // Import the next page

class AddListingPage extends StatefulWidget {
  const AddListingPage({super.key});

  @override
  _AddListingPageState createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  String? _selectedCategory = 'Land'; // Default category
  List<XFile>? _imageFiles = []; // List to hold selected images

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // Function to pick images
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    setState(() {
      if (pickedFiles != null) {
        _imageFiles = pickedFiles; // Update the list with selected images
      }
    });
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadImageToFirebase(XFile image) async {
    try {
      // Get a unique file name
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child('images/$fileName');

      // Upload the file
      File imageFile = File(image.path); // Convert XFile to File
      await storageRef.putFile(imageFile);

      // Get the download URL after uploading
      String downloadUrl = await storageRef.getDownloadURL();
      print("Image uploaded: $downloadUrl");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Function to upload all selected images
  Future<void> _uploadAllImages() async {
    if (_imageFiles != null && _imageFiles!.isNotEmpty) {
      for (XFile image in _imageFiles!) {
        await _uploadImageToFirebase(image);
      }
    }
  }

  // Function to handle navigation
  void _handleNextButton() {
    // Navigate to the next page without validation
    print("Navigating to the next screen...");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddListing2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Listing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Land'),
              leading: Radio<String>(
                value: 'Land',
                groupValue: _selectedCategory,
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Apartment'),
              leading: Radio<String>(
                value: 'Apartment',
                groupValue: _selectedCategory,
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Home'),
              leading: Radio<String>(
                value: 'Home',
                groupValue: _selectedCategory,
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                activeColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Images',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text(
                'Pick Images',
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            if (_imageFiles != null && _imageFiles!.isNotEmpty)
              Column(
                children: _imageFiles!
                    .map((image) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(image.path),
                            width: 100,
                            height: 100,
                          ),
                        ))
                    .toList(),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleNextButton, // Use the handle function for navigation
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
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