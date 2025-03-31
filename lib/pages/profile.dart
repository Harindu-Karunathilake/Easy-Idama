import 'package:flutter/material.dart';
import 'package:mad/pages/home.dart';
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
  String activeTab = 'Transaction';
  final ScrollController _scrollController = ScrollController();
  final List<String> tabs = ['Transaction', 'Listings', 'Sold', 'Reviews'];
  final PropertyService _propertyService = PropertyService();

  String userName = "User";
  String email = "Email";
  String? profileImageUrl;
  String userId = "";
  List<Map<String, dynamic>> userListings = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
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

  void _selectTab(String tab) {
    setState(() {
      activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
        ),
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
            SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs.map((tab) => _tabButton(tab)).toList(),
              ),
            ),
            const SizedBox(height: 10),
            if (activeTab == 'Listings') _emptySection('No listings available'),
            if (activeTab == 'Transaction') _emptySection('No transactions'),
            if (activeTab == 'Sold') _emptySection('No sold items yet'),
            if (activeTab == 'Reviews') _emptySection('No reviews yet'),
          ],
        ),
      ),
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

  Widget _emptySection(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}
