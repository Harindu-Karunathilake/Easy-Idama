import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'add_listing_2.dart';

class AddListingPage extends StatefulWidget {
  const AddListingPage({super.key});

  @override
  _AddListingPageState createState() => _AddListingPageState();
}

class _AddListingPageState extends State<AddListingPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory = 'Land';
  List<XFile>? _imageFiles = [];
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles = pickedFiles;
      });
    }
  }

  Future<String> _uploadImageToFirebase(XFile image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('listings/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  Future<void> _uploadAllImages() async {
    if (_imageFiles == null || _imageFiles!.isEmpty) return;
    List<String> imageUrls = [];
    for (XFile image in _imageFiles!) {
      String url = await _uploadImageToFirebase(image);
      if (url.isNotEmpty) {
        imageUrls.add(url);
      }
    }
    await _firestore.collection("Listings").add({
      "name": _nameController.text,
      "description": _descriptionController.text,
      "category": _selectedCategory,
      "imageUrls": imageUrls,
      "createdAt": Timestamp.now()
    });
  }

 void _handleNextButton() {
  if (_formKey.currentState!.validate() && _imageFiles!.isNotEmpty) {
    // Show loading indicator immediately
    final snackBar = SnackBar(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20),
          const Text('Uploading images...'),
        ],
      ),
      duration: const Duration(days: 1), // Long duration to prevent auto-hiding
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
    // Start upload in background
    Future(() => _uploadAllImages()).then((_) {
      // Hide loading indicator
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // Navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddListing2()),
      );
    }).catchError((error) {
      // Hide loading indicator and show error
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${error.toString()}')),
      );
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please complete all fields before proceeding."),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Listing')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Property Name',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextFormField(
  controller: _nameController,
  decoration: InputDecoration(
    hintText: 'Enter property name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.blue), // Blue border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.blue), // Blue when not focused
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0), // Blue when focused
    ),
  ),
  validator: (value) => value!.isEmpty ? 'Please enter a property name' : null,
),
const SizedBox(height: 16),
const Text(
  'Description',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
TextFormField(
  controller: _descriptionController,
  decoration: InputDecoration(
    hintText: 'Enter property description',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.blue), // Blue border
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.blue), // Blue when not focused
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Colors.blue, width: 2.0), // Blue when focused
    ),
  ),
  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
  maxLines: 3,
),

                const SizedBox(height: 16),
                const Text('Property Category',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
  title: const Text('Land'),
  leading: Radio<String>(
    value: 'Land',
    groupValue: _selectedCategory,
    activeColor: Colors.blue, // Set radio color to blue
    onChanged: (String? value) {
      setState(() {
        _selectedCategory = value;
      });
    },
  ),
),
ListTile(
  title: const Text('Apartment'),
  leading: Radio<String>(
    value: 'Apartment',
    groupValue: _selectedCategory,
    activeColor: Colors.blue, // Set radio color to blue
    onChanged: (String? value) {
      setState(() {
        _selectedCategory = value;
      });
    },
  ),
),
ListTile(
  title: const Text('Home'),
  leading: Radio<String>(
    value: 'Home',
    groupValue: _selectedCategory,
    activeColor: Colors.blue, // Set radio color to blue
    onChanged: (String? value) {
      setState(() {
        _selectedCategory = value;
      });
    },
  ),
),

                const SizedBox(height: 20),
                const Text('Add Images',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Pick Images', style: TextStyle(color: Colors.blue),),
                ),
                if (_imageFiles != null && _imageFiles!.isNotEmpty)
                  Wrap(
                    children: _imageFiles!.map((image) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(File(image.path),
                            width: 150, height: 150),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                Center(
                  child:  ElevatedButton(
                  onPressed: _handleNextButton, // Show the success popup
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
        ),
      ),
    );
  }
}
