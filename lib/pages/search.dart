import 'package:flutter/material.dart';
import 'package:mad/pages/land_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mad/widgets/navbar.dart';
import 'package:mad/models/Property_model.dart';
import 'package:mad/services/property_service.dart'; // Import your property service

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchHistory = [];
  List<Property> properties = []; // List of properties from your backend
  List<Property> filteredProperties = [];
  bool showSuggestions = false; // Controls when to show suggestions

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _fetchProperties(); // Fetch properties on load
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
    bool removed = await prefs.remove('searchHistory');
    setState(() {
      searchHistory.clear();
    });
  }

  Future<void> _fetchProperties() async {
    // Fetch properties from your service (e.g., Firebase or API)
    List<Property> fetchedProperties = await PropertyService().fetchProperties();
    setState(() {
      properties = fetchedProperties;
      filteredProperties = fetchedProperties; // Initially display all properties
    });
  }

  void _filterItems(String query) {
    setState(() {
      showSuggestions = query.isNotEmpty;
      filteredProperties = properties
          .where((property) => property.name.toLowerCase().contains(query.toLowerCase()))
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
    return filteredProperties.isNotEmpty
        ? ListView.builder(
            itemCount: filteredProperties.length,
            itemBuilder: (context, index) {
              final property = filteredProperties[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: property.imageUrls.isNotEmpty
                      ? Image.network(property.imageUrls[0], width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image_not_supported, size: 50),
                  title: Text(property.name),
                  subtitle: Text(property.location),
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
