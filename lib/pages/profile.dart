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
  String activeTab = 'Transaction'; // Default active tab
  final ScrollController _scrollController = ScrollController();
  final List<String> tabs = ['Transaction', 'Listings', 'Sold', 'Reviews'];
  int listingsCount = 0;
  int soldCount = 0;
  int reviewsCount = 0;

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
            const Text('mathew@gmail.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            if (activeTab == 'Transaction') _emptySection('No Transactions available'),
            if (activeTab == 'Listings') _emptySection('No listings available'),
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