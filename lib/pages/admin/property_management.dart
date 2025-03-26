import 'package:flutter/material.dart';
import 'package:mad/models/Property_model.dart';
import 'package:mad/services/property_service.dart';

class PropertyManagementPage extends StatefulWidget {
  @override
  _PropertyManagementPageState createState() => _PropertyManagementPageState();
}

class _PropertyManagementPageState extends State<PropertyManagementPage> {
  final PropertyService _propertyService = PropertyService();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  // Function to show a confirmation dialog before deleting
  void _confirmDelete(String propertyId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Property"),
          content: Text("Are you sure you want to delete this property?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await _propertyService.deleteProperty(propertyId);
                setState(() {}); // Refresh UI after delete
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Property Management')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Properties',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Property List
          Expanded(
            child: StreamBuilder<List<Property>>(
              stream: Stream.fromFuture(_propertyService.fetchProperties()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var properties = snapshot.data!.where((property) {
                  return property.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                         property.location.toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    var property = properties[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(property.name),
                        subtitle: Text("Location: ${property.location}\nPrice: ${property.price}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(property.id), // Show confirmation dialog
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
