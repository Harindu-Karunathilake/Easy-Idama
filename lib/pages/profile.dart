import 'package:flutter/material.dart';
import 'package:mad/widgets/navbar.dart';
import 'package:mad/pages/add_listing.dart';
//import 'package:mad/pages/sold.dart';
//import 'package:mad/pages/reviews.dart';
import 'package:mad/pages/edit_profile.dart';
import 'package:mad/pages/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String activeTab = 'Transaction'; // Default active tab
  final ScrollController _scrollController = ScrollController();
  final List<String> tabs = ['Transaction', 'Listings', 'Sold', 'Reviews'];

  String userName = "User";
  String email = "Email";
  String? profileImageUrl; // Profile image URL
  String userId = ""; // Logged-in user ID
  List<Map<String, dynamic>> userListings = []; // Stores user's listings

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // Fetch user details
  }

  // Fetch user info & listings
  void _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userId = user.uid; // Store logged-in user ID
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

        _fetchUserListings(); // Fetch listings after getting user info
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          userName = 'Error Loading Name';
        });
      }
    }
  }

  // Fetch only the listings added by the logged-in user
  void _fetchUserListings() async {
  try {
    // Get the current user ID from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Query the Listings collection where the userId matches the current user's ID
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Listings')
          .where('userId', isEqualTo: userId) // Filter by user ID
          .orderBy('createdAt', descending: true) // Sort by newest first
          .get();

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          userListings = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }

      print("✅ Fetched ${userListings.length} listings.");
    } else {
      print("❌ User not logged in");
    }
  } catch (e) {
    print("❌ Error fetching user listings: $e");
  }
}


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

            // "Add Listing" Button
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
                      _fetchUserListings(); // Refresh the listings
                    }
                  },
                  mini: true,
                  child: const Icon(Icons.add, size: 20),
                  backgroundColor: Colors.blue,
                ),
              ),

            const SizedBox(height: 20),

            // Display Listings or Empty Message
          if (activeTab == 'Listings')
  userListings.isNotEmpty
      ? Column(
          children: userListings.map((listing) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: listing['imageUrls'] != null && (listing['imageUrls'] as List).isNotEmpty
                    ? Image.network(
                        listing['imageUrls'][0], // Access the first image in the list
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.image_not_supported),
                title: Text(listing['name'] ?? 'No Title'),
                subtitle: Text("Price: \$${listing['price'] ?? 'N/A'}"),
              ),
            );
          }).toList(),
        )
      : _emptySection('No listings available'),


            if (activeTab == 'Transaction') _emptySection('No Transactions available'),
            if (activeTab == 'Sold') _emptySection('No sold items yet'),
            if (activeTab == 'Reviews') _emptySection('No reviews yet'),
          ],
        ),
      ),
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

  Widget _emptySection(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}
