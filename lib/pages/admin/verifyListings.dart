import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class VerifyListingPage extends StatefulWidget {
  const VerifyListingPage({super.key});

  @override
  State<VerifyListingPage> createState() => _VerifyListingPageState();
}

class _VerifyListingPageState extends State<VerifyListingPage> {
  List<Map<String, dynamic>> verifications = []; // Store verification data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVerifications();
  }

  // Fetch verification data from the verifications collection
  Future<void> _fetchVerifications() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('verifications')
          .where('verifyStatus', isEqualTo: 'pending') // Only fetch pending verifications
          .get();

      List<Map<String, dynamic>> fetchedVerifications = snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>, // Convert to Map
                'id': doc.id, // Add document ID as 'id'
              })
          .toList();

      setState(() {
        verifications = fetchedVerifications;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching verifications: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle the verification process (update the status in the verifications collection)
  Future<void> _verifyListing(String verificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('verifications')
          .doc(verificationId)
          .update({'verifyStatus': 'verified'}); // Update verify status to verified

      // After updating, refresh the verification data
      _fetchVerifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing successfully verified')),
      );
    } catch (e) {
      print("Error verifying listing: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error verifying listing')),
      );
    }
  }

  // Handle the rejection process (update the status in the verifications collection)
  Future<void> _rejectListing(String verificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('verifications')
          .doc(verificationId)
          .update({'verifyStatus': 'rejected'}); // Update verify status to rejected

      // After updating, refresh the verification data
      _fetchVerifications();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing successfully rejected')),
      );
    } catch (e) {
      print("Error rejecting listing: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error rejecting listing')),
      );
    }
  }

  // Fetch listing details using the listing ID
  Future<Map<String, dynamic>> _fetchListingDetails(String listingId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Listings')
          .doc(listingId)
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return empty map if listing not found
      }
    } catch (e) {
      print("Error fetching listing details: $e");
      return {}; // Return empty map on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verify Listings',
          style: TextStyle(color: Colors.white), // White text
        ),
        backgroundColor: Colors.blue, // Blue AppBar
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : ListView.builder(
              itemCount: verifications.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> verification = verifications[index];
                String listingId = verification['listingId'];

                return FutureBuilder<Map<String, dynamic>>(
                  future: _fetchListingDetails(listingId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox();
                    }

                    var listing = snapshot.data!;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ExpansionTile(
                        title: Text(listing['name'] ?? 'Untitled Listing'),
                        children: [
                          ListTile(
                            title: Text('Address: ${listing['location'] ?? 'Not Provided'}'),
                            subtitle: Text('Price: ${listing['price'] ?? 'Not Provided'}'),
                          ),
                          ListTile(
                            title: Text('Deed URL:'),
                            subtitle: TextButton(
                              onPressed: () {
                                final deedUrl = listing['propertyDeedUrl'] ?? '';
                                if (deedUrl.isNotEmpty) {
                                  _launchURL(deedUrl);
                                }
                              },
                              child: const Text('View Property Deed'),
                            ),
                          ),
                          ListTile(
                            title: Text('Plan URL:'),
                            subtitle: TextButton(
                              onPressed: () {
                                final planUrl = listing['propertyPlanUrl'] ?? '';
                                if (planUrl.isNotEmpty) {
                                  _launchURL(planUrl);
                                }
                              },
                              child: const Text('View Property Plan'),
                            ),
                          ),
                          ListTile(
                            title: ElevatedButton(
                              onPressed: () {
                                _showConfirmDialog(
                                  'Verify Listing',
                                  'Are you sure you want to verify this listing?',
                                  () {
                                    _verifyListing(verification['id']);
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white, // White text
                              ),
                              child: const Text('Verify Listing'),
                            ),
                          ),
                          ListTile(
                            title: ElevatedButton(
                              onPressed: () {
                                _showConfirmDialog(
                                  'Reject Listing',
                                  'Are you sure you want to reject this listing?',
                                  () {
                                    _rejectListing(verification['id']);
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white, // White text
                              ),
                              child: const Text('Reject Listing'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  // Open a URL in the web browser using url_launcher
  void _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      print("Could not launch $url");
    }
  }

  // Show a confirmation dialog
  void _showConfirmDialog(String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                onConfirm(); // Execute the action (verify or reject)
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
