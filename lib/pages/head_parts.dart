import 'package:flutter/material.dart';
import 'package:mad/pages/land_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:mad/providers/favourite_provider.dart';
import 'package:mad/models/Property_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HeaderParts extends StatefulWidget {
  const HeaderParts({super.key});

  @override
  _HeaderPartsState createState() => _HeaderPartsState();
}

class _HeaderPartsState extends State<HeaderParts> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "Home";
  String userName = "User";

  List<Map<String, String>> items = [
    {
      "name": "Beautiful Land in Kandy",
      "location": "Kandy, Sri Lanka",
      "image": 'assets/land.jpg',
      "category": "Land"
    },
    {
      "name": "Apartment in Colombo",
      "location": "Colombo, Sri Lanka",
      "image": 'assets/land.jpg',
      "category": "Apartment"
    },
    {
      "name": "Cozy Home in Galle",
      "location": "Galle, Sri Lanka",
      "image": 'assets/land.jpg',
      "category": "Home"
    },
    {
      "name": "Spacious Land in Jaffna",
      "location": "Jaffna, Sri Lanka",
      "image": 'assets/land.jpg',
      "category": "Land"
    },
  ];

  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    filteredItems = items;
    selectedCategory = "All";
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

  void _filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) =>
              item["name"]!.toLowerCase().contains(query.toLowerCase()) &&
              (selectedCategory == "All" || item["category"] == selectedCategory))
          .toList();
    });
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      _filterItems(_searchController.text);  // Re-filter based on the selected category
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
          _buildHeader(),
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

  Widget _buildHeader() {
    return AppBar(
  actions: [
    IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
    Padding(
      padding: EdgeInsets.all(10.0), // Add padding around the avatar
      child: CircleAvatar(
        backgroundImage: AssetImage(''), // Add your image path here
      ),
    ),
  ],
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
      child: TextField(
        controller: _searchController,
        onChanged: _filterItems,
        decoration: InputDecoration(
          hintText: "Search properties...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
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
              children: items.map((property) {
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
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return _buildPropertyCard(filteredItems[index]);
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, String> property) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        bool isFavorite = favoritesProvider.isFavorite(Property(
          name: property["name"]!,
          location: property["location"]!,
          image: property["image"]!,
          category: property["category"]!,
        ));

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LandDetailsScreen(property: property),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(property["image"]!, height: 130, width:400, fit: BoxFit.cover),
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
                          Text(property["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(property["location"]!, style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        ),
                      
                      IconButton(
                        icon: Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.grey),
                        onPressed: () {
                          favoritesProvider.toggleFavorite(Property(
                            name: property["name"]!,
                            location: property["location"]!,
                            image: property["image"]!,
                            category: property["category"]!,
                          ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
