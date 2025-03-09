import 'package:flutter/material.dart';
import 'package:mad/widgets/navbar.dart';
import 'package:mad/pages/add_listing.dart';
import 'package:mad/pages/sold.dart';
import 'package:mad/pages/reviews.dart';
import 'package:mad/pages/edit_profile.dart';
import 'package:mad/pages/settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String activeTab = 'Transaction';
  int listingsCount = 0;
  int soldCount = 0;
  int reviewsCount = 0;

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
                MaterialPageRoute(
                    builder: (context) => const EditProfilePage()),
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
          // You can add any logic here if needed when the tab changes.
          // For example, you might want to update some state.
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
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/man.jpg'),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mathew Adam',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('mathew@gmail.com',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoCard(listingsCount.toString(), 'Listings'),
                GestureDetector(
                  onTap: () async {
                    final updatedSoldCount = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SoldPage()),
                    );
                    if (updatedSoldCount != null) {
                      setState(() {
                        soldCount = updatedSoldCount;
                      });
                    }
                  },
                  child: _infoCard(soldCount.toString(), 'Sold'),
                ),
                GestureDetector(
                  onTap: () async {
                    final updatedReviewsCount = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReviewsPage()),
                    );
                    if (updatedReviewsCount != null) {
                      setState(() {
                        reviewsCount = updatedReviewsCount;
                      });
                    }
                  },
                  child: _infoCard(reviewsCount.toString(), 'Reviews'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _tabButton('Transaction'),
                      _tabButton('Listings'),
                      _tabButton('Sold'),
                      _tabButton('Reviews'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (activeTab == 'Listings')
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: () async {
                        final newItemAdded = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddListingPage()),
                        );
                        if (newItemAdded == true) {
                          setState(() {
                            listingsCount++;
                          });
                        }
                      },
                      mini: true,
                      child: const Icon(Icons.add, size: 20),
                      backgroundColor: Colors.blue,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (activeTab == 'Transaction')
              _emptySection('No Transactions available'),
            if (activeTab == 'Listings') _emptySection('No listings available'),
            if (activeTab == 'Sold') _emptySection('No sold item yet'),
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
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/man.jpg'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _tabButton(String label) {
    bool isActive = label == activeTab;
    return TextButton(
      onPressed: () {
        setState(() {
          activeTab = label;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.white : Colors.blue,
        backgroundColor: isActive ? Colors.blue : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _infoCard(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _emptySection(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
