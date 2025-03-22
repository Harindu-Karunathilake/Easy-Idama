import 'package:flutter/material.dart';
import 'package:mad/pages/land_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mad/widgets/navbar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchHistory = [];
  List<Map<String, String>> items = [
    {"name": "Beautiful Land in Kandy", "location": "Kandy, Sri Lanka", "image": 'assets/land.jpg', "category": "Land"},
    {"name": "Apartment in Colombo", "location": "Colombo, Sri Lanka", "image": 'assets/land.jpg', "category": "Apartment"},
    {"name": "Cozy Home in Galle", "location": "Galle, Sri Lanka", "image": 'assets/land.jpg', "category": "Home"},
    {"name": "Spacious Land in Jaffna", "location": "Jaffna, Sri Lanka", "image": 'assets/land.jpg', "category": "Land"},
  ];
  List<Map<String, String>> filteredItems = [];
  bool showSuggestions = false; // Controls when to show suggestions

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList('searchHistory') ?? [];
    });
  }

  Future<void> _saveSearchHistory(String query) async {
    if (!searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      if (searchHistory.length > 5) {
        searchHistory.removeLast();
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('searchHistory', searchHistory);
    }
  }

 Future<void> _clearSearchHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Before removal, print the current search history
  print("Before removal: ${prefs.getStringList('searchHistory')}");

  // Remove search history from SharedPreferences
  bool removed = await prefs.remove('searchHistory');
  print('Search history removed: $removed');
  
  // Clear the in-memory list and update the UI
  setState(() {
    searchHistory.clear();
    print('Search history cleared');
  });

  // After removal, print the current search history again
  print("After removal: ${prefs.getStringList('searchHistory')}");
}


  void _filterItems(String query) {
    setState(() {
      showSuggestions = query.isNotEmpty;
      filteredItems = items
          .where((item) => item["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onSearch(String query) {
    _saveSearchHistory(query);
    _filterItems(query);
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Search')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterItems,
                onSubmitted: _onSearch,
                decoration: InputDecoration(
                  hintText: "Search properties...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),

            // Show search history if no input
            if (!showSuggestions && searchHistory.isNotEmpty) _buildSearchHistory(),

            // Show property suggestions only when user starts searching
            if (showSuggestions) Expanded(child: _buildPropertySuggestions()),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: 1, 
          onTabChange: (index) => print('Tab changed to index: $index'),
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Searches", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: _clearSearchHistory,
                child: Text("Clear", style: TextStyle(color: Colors.red)),
              )
            ],
          ),
          Wrap(
            spacing: 8,
            children: searchHistory.map((search) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = search;
                  _onSearch(search);
                },
                child: Chip(label: Text(search)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertySuggestions() {
    return filteredItems.isNotEmpty
        ? ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final property = filteredItems[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.asset(property["image"]!, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(property["name"]!),
                  subtitle: Text(property["location"]!),
                  onTap: () {
                    // Navigate to property details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LandDetailsScreen(property: property),
                      ),
                    );
                  },
                ),
              );
            },
          )
        : Center(child: Text("No results found."));
  }
}
