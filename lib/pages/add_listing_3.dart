import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_selector/file_selector.dart';
import 'add_listing_4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddListing3 extends StatefulWidget {
  const AddListing3({super.key});

  @override
  _AddListing3State createState() => _AddListing3State();
}

class _AddListing3State extends State<AddListing3> {
  final TextEditingController _priceController = TextEditingController();
  String _selectedCurrency = 'USD';
  final List<String> _currencies = ['USD', 'LKR', 'EUR'];
  String? propertyPlanUrl;
  String? propertyDeedUrl;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> _uploadFile(File file, String fileName) async {
    try {
      Reference storageRef = _storage.ref().child('documents/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }

  Future<void> _pickAndUploadFile(bool isPlan) async {
    final XFile? file = await openFile(acceptedTypeGroups: [
      XTypeGroup(extensions: ['pdf'])
    ]);

    if (file != null) {
      File localFile = File(file.path);
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.pdf';
      String? downloadUrl = await _uploadFile(localFile, fileName);

      if (downloadUrl != null) {
        setState(() {
          if (isPlan) {
            propertyPlanUrl = downloadUrl;
          } else {
            propertyDeedUrl = downloadUrl;
          }
        });
      }
    }
  }

  void _handleNextButton() async {
    if (_priceController.text.isEmpty || propertyPlanUrl == null || propertyDeedUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields before proceeding.")),
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
          "price": _priceController.text,
          "currency": _selectedCurrency,
          "propertyPlanUrl": propertyPlanUrl,
          "propertyDeedUrl": propertyDeedUrl,
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddListing4()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No listing found to update.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating listing: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Listing - Step 3')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Just one more step! Complete your listing.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text('Sell Price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCurrency = newValue!;
                    });
                  },
                  items: _currencies.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Add Property Plan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _pickAndUploadFile(true),
              icon: const Icon(Icons.upload, color: Colors.white),
              label: Text(propertyPlanUrl != null ? 'Uploaded' : 'Upload Property Plan'),
            ),
            const SizedBox(height: 20),

            const Text('Add Property Deed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _pickAndUploadFile(false),
              icon: const Icon(Icons.upload, color: Colors.white),
              label: Text(propertyDeedUrl != null ? 'Uploaded' : 'Upload Property Deed'),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleNextButton,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // change button color to blue
                child: const Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}