import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mad/providers/favourite_provider.dart';
import 'package:mad/models/Property_model.dart';
import 'package:firebase_auth/firebase_auth.dart';



class HeaderParts extends StatefulWidget {
  const HeaderParts({super.key});

  @override
  _HeaderPartsState createState() => _HeaderPartsState();
}

class _HeaderPartsState extends State<HeaderParts> {
    
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = "Home";
  bool isFavorite = false;
  String userName = "User"; // Default name

  List<Map<String, String>> items = [
    {"name": "Beautiful Land in Kandy", "location": "Kandy, Sri Lanka", "image": 'assets/land.jpg',"catoegary":"Land"},
    {"name": "Apartment in Colombo", "location": "Colombo, Sri Lanka", "image": 'assets/land.jpg',"catoegary":"Apartment"},
    {"name": "Cozy Home in Galle", "location": "Galle, Sri Lanka", "image": 'assets/land.jpg',"catoegary":"Home"},
    {"name": "Spacious Land in Jaffna", "location": "Jaffna, Sri Lanka", "image": 'assets/land.jpg',"catoegary":"Land"},
   
  ];

  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // Fetch user info from Firebase
    filteredItems = items; // Initially show all items
  }

  void _getUserInfo() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      setState(() {
        userName = user.displayName!;
      });
    }
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items.where((item) {
        return item["name"]!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

   void _selectCategory(String category) {
    _searchController.text = category; // Set category as search text
    _filterItems(category); // Filter based on category
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 16), // Avoid pixel overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            _buildGreeting(),
            const SizedBox(height: 15),
            _buildSearchBar(),
            const SizedBox(height: 15),
            _buildCategorySelection(),
            const SizedBox(height: 20),
            _buildPopularSection(),
            const SizedBox(height: 20),
            _buildRecommendedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hey, $userName!",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "Let's start exploring",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        onChanged: _filterItems, // Call search function
        decoration: InputDecoration(
          hintText: "Search properties...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategoryButton("Home"),
          _buildCategoryButton("Land"),
          _buildCategoryButton("Apartment"),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        _selectCategory(category);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: selectedCategory == category ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selectedCategory == category ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: selectedCategory == category ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPopularSection() {
    return _buildHorizontalList(title: "Popular");
  }

  Widget _buildRecommendedSection() {
    return _buildHorizontalList(title: "Recommended");
  }

  Widget _buildHorizontalList({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filteredItems.map((property) => _buildPopularCard(property)).toList(),
            ),
          ),
        ],
      ),
    );
  }


Widget _buildPopularCard(Map<String, String> property) {
  return Consumer<FavoritesProvider>(
    builder: (context, favoritesProvider, child) {
      bool isFavorite = favoritesProvider.isFavorite(
        Property(
          name: property["name"]!,
          location: property["location"]!,
          image: property["image"]!,
          category: property["catoegary"]!,
        ),
      );

      return Container(
        width: 250,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade100, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  property["image"]!,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 130,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property["name"]!,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            property["location"]!,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.grey),
                      onPressed: () {
                        favoritesProvider.toggleFavorite(
                          Property(
                            name: property["name"]!,
                            location: property["location"]!,
                            image: property["image"]!,
                            category: property["catoegary"]!,
                          ),
                        );
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



  


