import 'package:flutter/material.dart';
import 'package:mad/pages/verify.dart';
import 'package:mad/widgets/navbar.dart';
import 'package:mad/pages/add_listing.dart';
import 'package:mad/pages/edit_profile.dart';
import 'package:mad/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad/services/property_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State variables
  String activeTab = 'Transaction';
  final ScrollController _scrollController = ScrollController();
  final List<String> tabs = ['Transaction', 'Listings', 'Sold', 'Reviews'];
  final PropertyService _propertyService = PropertyService();

  String _verificationStatus = 'not_verified';
  String userName = "User";
  String email = "Email";
  String? profileImageUrl;
  String userId = "";
  List<Map<String, dynamic>> userListings = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _fetchVerificationStatus('defaultPropertyId');
  }

  // --- Firebase Methods ---

 Future<String> _fetchVerificationStatus(String propertyId) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('verifications')
        .where('listingId', isEqualTo: propertyId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['verifyStatus'] ?? 'not_verified';
    }
    return 'not_verified';
  } catch (e) {
    print("Error fetching verification status: $e");
    return 'not_verified';
  }
}


  Future<List<Map<String, dynamic>>> _getUserVerificationsWithListingNames() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot verificationSnapshot = await FirebaseFirestore.instance
            .collection('verifications')
            .where('userId', isEqualTo: user.uid)
            .get();

        List<Map<String, dynamic>> enrichedVerifications = [];
        for (var doc in verificationSnapshot.docs) {
          Map<String, dynamic> verification = doc.data() as Map<String, dynamic>;
          String listingId = verification['listingId'];

          DocumentSnapshot listingSnapshot = await FirebaseFirestore.instance
              .collection('Listings')
              .doc(listingId)
              .get();

          verification['listingName'] = listingSnapshot.exists
              ? listingSnapshot['name'] ?? 'Unnamed Property'
              : 'Unknown Listing';

          enrichedVerifications.add(verification);
        }
        return enrichedVerifications;
      } catch (e) {
        print("Error fetching enriched verifications: $e");
        return [];
      }
    } else {
      return [];
    }
  }

  void _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'] ?? 'Unknown User';
            email = userDoc['email'] ?? 'Unknown Email';
            profileImageUrl = userDoc['profileImageUrl'];
          });
        }
        _fetchUserListings();
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          userName = 'Error Loading Name';
        });
      }
    }
  }

  void _fetchUserListings() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Listings')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        if (mounted) {
          setState(() {
            userListings = snapshot.docs
                .map((doc) => {
                      ...doc.data() as Map<String, dynamic>,
                      'id': doc.id,
                    })
                .toList();
          });
        }
      }
    } catch (e) {
      print("Error fetching user listings: $e");
    }
  }

  // --- UI Helper Methods ---

  void _selectTab(String tab) {
    setState(() {
      activeTab = tab;
    });
    int index = tabs.indexOf(tab);
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = 100;
    double scrollTo = (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);
    _scrollController.animateTo(
      scrollTo.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleVerification(String propertyId) {
    if (_verificationStatus == 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification is already pending')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyScreen(listingId: propertyId),
      ),
    );
  }

  void _confirmDelete(String propertyId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Property"),
          content: const Text("Are you sure you want to delete this property?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _propertyService.deleteProperty(propertyId);
                setState(() {
                  _fetchUserListings();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showProfilePicture() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.network(profileImageUrl ?? ''),
          ),
        );
      },
    );
  }

  Widget _tabButton(String tabName) {
    bool isSelected = activeTab == tabName;
    return GestureDetector(
      onTap: () => _selectTab(tabName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tabName,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationItemWithListingName(Map<String, dynamic> verification) {
    String verifyStatus = verification['verifyStatus'] ?? 'pending';
    String listingName = verification['listingName'] ?? 'Unnamed Property';

    Icon statusIcon;
    if (verifyStatus == 'verified') {
      statusIcon = const Icon(Icons.verified, color: Colors.green);
    } else if (verifyStatus == 'rejected') {
      statusIcon = const Icon(Icons.cancel, color: Colors.red);
    } else {
      statusIcon = const Icon(Icons.hourglass_empty, color: Colors.orange);
    }

    return ListTile(
      title: Text(listingName),
      subtitle: Text('Status: $verifyStatus'),
      trailing: statusIcon,
    );
  }

  Widget _emptySection(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 3,
        onTabChange: (index) {
          print('Tab changed to index: $index');
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : const AssetImage('assets/profile.jpg') as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tabs.map((tab) => _tabButton(tab)).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Add Listing Button
           if (activeTab == 'Listings')
  Align(
    alignment: Alignment.centerRight,
    child: FloatingActionButton(
      onPressed: () async {
        final newItemAdded = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddListingPage()),
        );
        if (newItemAdded == true) {
          _fetchUserListings();
        }
      },
      mini: true,
      child: const Icon(Icons.add, size: 20),
      backgroundColor: Colors.blue,
    ),
  ),
const SizedBox(height: 20),
// Tab Content
if (activeTab == 'Listings')
  userListings.isNotEmpty
      ? Column(
          children: userListings.map((listing) {
            return FutureBuilder(
              future: _fetchVerificationStatus(listing['id']),
              builder: (context, snapshot) {
                // Default status if loading or error occurs
                String verifyStatus = snapshot.data ?? 'not_verified';

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: listing['imageUrls'] != null &&
                            (listing['imageUrls'] as List).isNotEmpty
                        ? Image.network(
                            listing['imageUrls'][0],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(listing['name'] ?? 'No Title'),
                    subtitle: Text("Price: \$${listing['price'] ?? 'N/A'}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (verifyStatus == 'pending')
                          ElevatedButton(
                            onPressed: null, // Disable the button
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            child: const Text(
                              'Pending',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        else if (verifyStatus == 'verified')
                          const Icon(Icons.verified, color: Colors.green)
                        else
                          TextButton(
                            onPressed: () async {
                              String? propertyId = listing['id'];
                              if (propertyId != null && propertyId.isNotEmpty) {
                                await _fetchVerificationStatus(propertyId);
                                _handleVerification(propertyId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Invalid property ID')),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            String? propertyId = listing['id'];
                            if (propertyId != null && propertyId.isNotEmpty) {
                              _confirmDelete(propertyId);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Invalid property ID')),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        )
      : _emptySection('No listings available'),
            if (activeTab == 'Transaction')
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _getUserVerificationsWithListingNames(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _emptySection('Error loading verifications');
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildVerificationItemWithListingName(snapshot.data![index]);
                        },
                      ),
                    );
                  } else {
                    return _emptySection('No verifications requested');
                  }
                },
              ),
            if (activeTab == 'Sold') _emptySection('No sold items yet'),
            if (activeTab == 'Reviews') _emptySection('No reviews yet'),
          ],
        ),
      ),
    );
  }
}
