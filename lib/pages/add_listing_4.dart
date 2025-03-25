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

  // Function to show success modal bottom sheet
  void _showSuccessPopup() {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // Prevents closing when tapping outside
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(
                thickness: 3,
                indent: 100,
                endIndent: 100,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Icon(Icons.check, size: 35, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "Your listing is now",
                style: TextStyle(fontSize: 18),
              ),
              const Text(
                "published",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your property is added to the profile",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close popup
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Add More",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close popup
                      Navigator.pop(context); // Go back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      "Finish",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
                onPressed: _showSuccessPopup, // Show the success popup
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
