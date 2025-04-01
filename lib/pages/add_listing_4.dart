import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mad/pages/home.dart';

class AddListing4 extends StatefulWidget {
  const AddListing4({super.key});

  @override
  _AddListing4State createState() => _AddListing4State();
}

class _AddListing4State extends State<AddListing4> {
  final TextEditingController _featureController = TextEditingController();
  List<String> _features = [];

  // Add a new feature
  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  // Remove a feature
  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  // Store user ID and features array in Firestore
  Future<void> _storeUserIdInListing() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("❌ No user logged in");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not logged in.")),
          );
        }
        return;
      }

      // Fetch the latest listing document
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Listings")
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String listingId = querySnapshot.docs.first.id;

        // Update Firestore with userId and features array
        await FirebaseFirestore.instance.collection("Listings").doc(listingId).update({
          "userId": user.uid,
          "features": _features, // Store features as an array
        });

        print("✅ User ID and Features stored successfully");
      } else {
        print("❌ No listing found to update.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No listing found to update.")),
          );
        }
      }
    } catch (e) {
      print("❌ Firestore Update Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating listing: $e")),
        );
      }
    }
  }

  // Show success popup after storing data
  void _showSuccessPopup() async {
    await _storeUserIdInListing(); // Store user ID and features

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(thickness: 3, indent: 100, endIndent: 100, color: Colors.grey),
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.check, size: 35, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text("Your listing is now", style: TextStyle(fontSize: 18)),
                const Text("published", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  "Your property is added to the profile",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text("Add More", style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text("Finish", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Listing - Step 4')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Almost finished, complete the listing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              const Text('Property Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _featureController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a feature',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addFeature,
                    child: const Text('Add', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Display the list of features
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _features.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_features[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFeature(index),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showSuccessPopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Next', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
