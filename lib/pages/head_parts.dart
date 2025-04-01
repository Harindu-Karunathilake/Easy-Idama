import 'package:flutter/material.dart';
import 'package:mad/pages/chats.dart';
import 'package:mad/pages/land_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:mad/providers/favourite_provider.dart';
import 'package:mad/models/Property_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad/pages/map.dart';
import 'package:mad/pages/search.dart';
//import 'package:mad/providers/property_provider.dart';
import '../services/property_service.dart'; 

class HeaderParts extends StatefulWidget {
  const HeaderParts({super.key});

  @override
  _HeaderPartsState createState() => _HeaderPartsState();
}

class _HeaderPartsState extends State<HeaderParts> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "All";
  String userName = "User";

  List<Property> allProperties = [];
  List<Property> filteredProperties = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _fetchProperties();
  }

  void _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'] ?? 'Unknown User';
          });
        } else {
          setState(() {
            userName = 'No Name Found';
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
        setState(() {
          userName = 'Error Loading Name';
        });
      }
    }
  }

  void _fetchProperties() async {
    List<Property> properties = await PropertyService().fetchProperties();
    setState(() {
      allProperties = properties;
      filteredProperties = properties;  // Initially show all properties
    });
  }

  void _filterItems(String query) {
    setState(() {
      filteredProperties = allProperties
          .where((property) =>
              property.name.toLowerCase().contains(query.toLowerCase()) &&
              (selectedCategory == "All" || property.category == selectedCategory))
          .toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      _filterItems(_searchController.text); // Re-filter based on the selected category
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showPopularRecommended =
        selectedCategory == "All" && _searchController.text.isEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildGreeting(),
          _buildSearchBar(),
          _buildCategorySelection(),
          if (showPopularRecommended) ...[
            _buildHorizontalList(title: "Popular"),
            _buildHorizontalList(title: "Recommended"),
          ],
          _buildFilteredPropertyList(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    "Colombo, Sri Lanka",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatsScreen()),
                  );
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100, 80, 0, 0),
                    items: [
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                          onTap: () async {
                            Navigator.pop(context); // Close the popup menu before logging out
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushReplacementNamed('/signin');
                          },
                        ),
                      ),
                    ],
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage('https://i.postimg.cc/cCsYDjvj/user-2.pngg'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text("Hey, $userName!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Text("Search properties...", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    List<String> categories = ["All", "Home", "Land", "Apartment"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: _buildCategoryButton(category),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () => _selectCategory(category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selectedCategory == category ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            color: selectedCategory == category ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalList({required String title}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filteredProperties.map((property) {
                return Container(
                  width: 250,
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: _buildPropertyCard(property),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredPropertyList() {
    bool isSearchOrCategoryActive = _searchController.text.isNotEmpty || selectedCategory != "All";

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isSearchOrCategoryActive)
            Text("Results", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          isSearchOrCategoryActive
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filteredProperties.length,
                  itemBuilder: (context, index) {
                    Property property = filteredProperties[index];
                    return _buildPropertyCard(property);
                  },
                )
              : Container(),
        ],
      ),
    );
  }

Widget _buildPropertyCard(Property property) {
  return Consumer<FavoritesProvider>(builder: (context, favoritesProvider, child) {
    bool isFavorite = favoritesProvider.isFavorite(property);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LandDetailsScreen(property: property),
          ),
        );
      },
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('verifications')
            .where('listingId', isEqualTo: property.id) // Check for matching listingId
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(); // Return an empty container while waiting for data
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          bool isVerified = false;

          // Check if the verification document exists and if it's verified
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var verificationData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

            // Ensure that verifyStatus is "verified"
            if (verificationData['verifyStatus'] == 'verified') {
              isVerified = true;
            }
          }

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    property.imageUrls.isNotEmpty ? property.imageUrls.first : '',
                    height: 130, 
                    width: 400, 
                    fit: BoxFit.cover
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              property.location,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // If verified, show the checkmark
                          if (isVerified)
                            Icon(
                              Icons.verified,
                              color: Colors.green,
                              size: 24,
                            ),
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              favoritesProvider.toggleFavorite(property);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  });
}



}
