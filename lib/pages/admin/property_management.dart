import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyManagementPage extends StatefulWidget {
  @override
  _PropertyManagementPageState createState() => _PropertyManagementPageState();
}

class _PropertyManagementPageState extends State<PropertyManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  Stream<QuerySnapshot> _getProperties() {
    return _firestore.collection('properties').snapshots();
  }

  void _deleteProperty(String docId) {
    _firestore.collection('properties').doc(docId).delete();
  }

  void _editProperty(String docId, Map<String, dynamic> propertyData) {
    TextEditingController titleController = TextEditingController(text: propertyData['title']);
    TextEditingController locationController = TextEditingController(text: propertyData['location']);
    TextEditingController priceController = TextEditingController(text: propertyData['price']);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Property"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
              TextField(controller: locationController, decoration: InputDecoration(labelText: "Location")),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _firestore.collection('properties').doc(docId).update({
                  'title': titleController.text,
                  'location': locationController.text,
                  'price': priceController.text,
                });
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _addProperty() {
    TextEditingController titleController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Property"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
              TextField(controller: locationController, decoration: InputDecoration(labelText: "Location")),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _firestore.collection('properties').add({
                  'title': titleController.text,
                  'location': locationController.text,
                  'price': priceController.text,
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getProperties(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var properties = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                         data['location'].toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();
                
                return ListView.builder(
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    var property = properties[index].data() as Map<String, dynamic>;
                    String docId = properties[index].id;
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(property['title']),
                        subtitle: Text("Location: \${property['location']}\nPrice: \${property['price']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editProperty(docId, property),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteProperty(docId),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addProperty,
        child: Icon(Icons.add),
      ),
    );
  }
}
