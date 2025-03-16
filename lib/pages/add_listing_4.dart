import 'package:flutter/material.dart';

class AddListing4 extends StatefulWidget {
  const AddListing4({super.key});

  @override
  _AddListing4State createState() => _AddListing4State();
}

class _AddListing4State extends State<AddListing4> {
  final TextEditingController _featureController = TextEditingController();
  List<String> _features = [];

  // Function to add a new feature
  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  // Function to remove a feature
  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Listing - Step 4')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Almost finished, complete the listing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              'Property Features',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Input field to add a new feature
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _featureController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a feature',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addFeature,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Display the list of features
            Expanded(
              child: ListView.builder(
                itemCount: _features.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_features[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFeature(index),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to AddListing5
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ()),
                  );*/
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}